
import Foundation

protocol EndPointType {
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
    var task: HTTPTask { get }
    var headers: HTTPHeaders? { get }
    var parameters: Parameters { get }
    var queryParametrs : [URLQueryItem] { get }
}

typealias NetworkRouterCompletion = (_ result : Result<Codable, Error>)->()

protocol NetworkRouter: class {
    associatedtype EndPoint: EndPointType
    func request<T>(_ route: EndPoint, type: T.Type, completion: @escaping (_ result : Result<T, Error>)->()) where T: Codable
    func request<T>(_ route: EndPoint, type: T.Type, file: UploadableFile, completion: @escaping (Result<T, Error>) -> ()) where T: Codable
    func cancel()
}
