
import Foundation

class HTTPRequest<EndPoint: EndPointType>: NetworkRouter {
    var task: URLSessionTask?
    func request<T>(_ route: EndPoint, type: T.Type, completion: @escaping (Result<T, Error>) -> ()) where T: Codable {
        let session = URLSession.shared
        do {
            let request = try self.buildRequest(from: route)
            NetworkLogger.log(request: request)
            task = session.dataTask(with: request, completionHandler: { (data, response, error) in
                defer {
                    self.task = nil
                }
                DispatchQueue.main.async {
                    if error != nil {
                        completion(.failure(error!))
                    } else if
                        let data = data,
                        let response = response as? HTTPURLResponse,
                        response.statusCode == 200 {
                        self.parseResult(with: data, completion: completion)
                        return
                    }else if let data = data {
                        self.parseError(with: data, completion: completion)
                    }else {
                        completion(.failure(ServiceError.emptyResponse))
                    }
                }
            })
            
        }catch {
            completion(.failure(error))
        }
        self.task?.resume()
    }
    
    func cancel() {
        self.task?.cancel()
    }
    
    fileprivate
    func buildRequest(from route: EndPoint) throws -> URLRequest {
        
      
        var apiUrl = route.baseURL.appendingPathComponent(route.path)
        
        if !route.queryParametrs.isEmpty{
            var urlComponents = URLComponents(url: apiUrl, resolvingAgainstBaseURL: true)
            urlComponents?.queryItems = route.queryParametrs
            apiUrl = (urlComponents?.url!)!
        }
        
        var request = URLRequest(url: apiUrl,
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: 10.0)
      
        request.httpMethod = route.httpMethod.rawValue
        do {
            switch route.task {
            case .request:
                  request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                self.addAdditionalHeaders(route.headers, request: &request)
                
            case .requestParameters(let bodyParameters,
                                    let bodyEncoding,
                                    let urlParameters):
                
                try self.configureParameters(bodyParameters: bodyParameters,
                                             bodyEncoding: bodyEncoding,
                                             urlParameters: urlParameters,
                                             request: &request)
                self.addAdditionalHeaders(route.headers, request: &request)
                
            case .requestParametersWithFile(let bodyParameters, let bodyEncoding, let urlParameters):
                
                try self.configureParameters(bodyParameters: bodyParameters,
                                             bodyEncoding: bodyEncoding,
                                             urlParameters: urlParameters,
                                             request: &request)
                self.addAdditionalHeaders(route.headers, request: &request)
            }
            return request
        } catch {
            throw error
        }
    }
    
    fileprivate func configureParameters(bodyParameters: Parameters?,
                                         bodyEncoding: ParameterEncoding,
                                         urlParameters: Parameters?,
                                         request: inout URLRequest) throws {
        do {
            try bodyEncoding.encode(urlRequest: &request,
                                    bodyParameters: bodyParameters, urlParameters: urlParameters)
        } catch {
            throw error
        }
    }
    
    fileprivate func addAdditionalHeaders(_ additionalHeaders: HTTPHeaders?, request: inout URLRequest) {
        guard let headers = additionalHeaders else { return }
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
    
    func parsedModel<T: Codable>(with data: Data, completion: @escaping (Result<T, Error>) -> ()) {
        
        do {
            let decoder = JSONDecoder()
            let model =  try decoder.decode(T.self, from: data)
            completion(.success(model))
            
        } catch {
            
            completion(.failure(error))
        }
    }
    
    func parseError<T>(with data: Data, completion: @escaping (Result<T, Error>) -> ()) {
        
        do {
            
            let jsonDict = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: AnyObject]
            
            if let message = jsonDict["message"] as? String {
                completion(.failure((ServiceError.errorMesaage(message))))
            }else {
                completion(.failure((ServiceError.errorMesaage("Something went wrong"))))
            }
            
        }catch {
            
            completion(.failure(error))
        }
    }
    
    private func parseResult<T: Codable>(with data: Data, completion: @escaping (Result<T, Error>) -> ()) {
        
        do {
            let jsonDict = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: AnyObject]
            print(jsonDict)
            if let status = jsonDict["status"] as? Int, status == 200 || status == 400 || status == 401 || status == 500 || status == 201 || status == 403 || status == 0{
                self.parsedModel(with: data, completion: completion)
            }else {
                print("No status code found")
                completion(.failure((ServiceError.errorMesaage(jsonDict["message"] as? String ?? "Something went wrong"))))
                return
            }
            
        }catch {
            
            completion(.failure(error))
            return
        }
        
    }
}


// MARK:- Upload Functions

extension HTTPRequest {
    
    func request<T>(_ route: EndPoint, type: T.Type, file: UploadableFile, completion: @escaping (Result<T, Error>) -> ()) where T: Codable {
        
        let formFields = route.parameters
        let imageData = file.data
        
        let boundary = "Boundary-\(UUID().uuidString)"
        
        var request = URLRequest(url: route.baseURL.appendingPathComponent(route.path),
                                 cachePolicy: .reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let httpBody = NSMutableData()
        
        for (key, value) in formFields {
            httpBody.appendString(convertFormField(named: key, value: value as? String ?? "", using: boundary))
        }
        
        httpBody.append(convertFileData(fieldName: file.param,
                                        fileName: file.fileName,
                                        mimeType: file.type.mimyType,
                                        fileData: imageData,
                                        using: boundary))
        
        httpBody.appendString("--\(boundary)--")
        
        request.httpBody = httpBody as Data
        let session = URLSession.shared
        NetworkLogger.log(request: request)
        task = session.dataTask(with: request, completionHandler: { (data, response, error) in
            defer {
                self.task = nil
            }
            DispatchQueue.main.async {
                if error != nil {
                    completion(.failure(error!))
                    
                } else if
                    let data = data,
                    let response = response as? HTTPURLResponse,
                    response.statusCode == 200 {
                    self.parseResult(with: data, completion: completion)
                    return
                }else if let data = data {
                    self.parseError(with: data, completion: completion)
                }else {
                    completion(.failure(ServiceError.emptyResponse))
                }
            }
        })
        self.task?.resume()
    }
    
    func convertFileData(fieldName: String, fileName: String, mimeType: String, fileData: Data, using boundary: String) -> Data {
        let data = NSMutableData()
        data.appendString("--\(boundary)\r\n")
        data.appendString("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n")
        data.appendString("Content-Type: \(mimeType)\r\n\r\n")
        data.append(fileData)
        data.appendString("\r\n")
        return data as Data
    }
    
    func convertFormField(named name: String, value: String, using boundary: String) -> String {
        var fieldString = "--\(boundary)\r\n"
        fieldString += "Content-Disposition: form-data; name=\"\(name)\"\r\n"
        fieldString += "\r\n"
        fieldString += "\(value)\r\n"
        return fieldString
    }
    
    
    
}

extension NSMutableData {
    func appendString(_ string: String) {
        if let data = string.data(using: .utf8) {
            self.append(data)
        }
    }
}
