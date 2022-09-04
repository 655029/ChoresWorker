//
//  UserJobEndPoints.swift
//  ShowAide
//
//  Created by BrightRootsMohini on 7/20/20.
//  Copyright © 2020 BrightRootsMohini. All rights reserved.
//
//http://3.128.96.192:3000/api/v1/update-showing-details
import Foundation

enum UserJobEndPoints {
    case get_All_Jobs
    case create_job(Parameters)
    case getMyJob
    case deleteJob(Parameters)
    case postShowDetails(Parameters)
    case apply_job(Parameters)
    case reject_job(Parameters)
    case updateJobTask(Parameters)
    case updatejobDetail(Parameters)
    case saveTransectionData(Parameters)
    case getJobDetails(Int)
    case addJobDetail(Parameters)
    case removeJobDetails(Parameters)
    case addRating(Parameters)
    case finishJob(Parameters)
    case getAgentAvailability(_ query : [URLQueryItem])
    case getAccountStatus
    case getHireJobPrice(_ query : [URLQueryItem])
    case getShowingDetails
    case getShowJobPrice(_ query : [URLQueryItem])
    case updateShowingDetail(Parameters)
    case cancelMyJob(Parameters)
}


extension UserJobEndPoints: EndPointType {
    var baseURL: URL {
        guard let url = URL(string: ApiConstants.ProductionServer.baseURL) else { fatalError("baseURL could not be configured.")}
        return url
    }

    var path: String {
        switch self {
        case .create_job(_):
            return "create-job"
        case .getMyJob:
            return UserStoreSingleton.shared.userType == "Hiring Agent" ? "get-my-job" : "get-job"
        case .deleteJob(_):
            return "delete-job"
        case .postShowDetails(_):
            return "add-showing-details"
        case .get_All_Jobs:
            return "get-all-jobs"
        case .apply_job(_):
            return "apply-job"
        case .reject_job(_):
            return "reject-job"
        case .updateJobTask(_):
            return "update-task"
        case .updatejobDetail(_):
            return "update-jobDetails"
        case .saveTransectionData(_):
            return "save-transaction-data"
        case .getJobDetails(let jobId):
            return "get-jobDetails/" + "\(jobId)"
        case .addJobDetail(_):
            return "add-jobDetails"
        case .removeJobDetails(_):
            return "remove-jobDetails"
        case .addRating(_):
            return "add-rating"
        case .finishJob(_):
            return "finish-job"
        case .getAgentAvailability:
            return "agent-availability"
        case .getAccountStatus:
            return "account-status"
        case .getHireJobPrice(_):
            return "prices"
        case .getShowingDetails:
           return "get-showing-details"
        case .getShowJobPrice(_):
            return "showing-prices"
        case .updateShowingDetail(_):
            return "update-showing-details"
        case .cancelMyJob(_):
            return "cancel-job"
        }
    }
    var httpMethod: HTTPMethod {
        switch self {
        case .create_job(_):
            return .post
        case .getMyJob,.get_All_Jobs,.getJobDetails(_),.getAgentAvailability(_),.getAccountStatus,.getHireJobPrice(_),.getShowingDetails,.getShowJobPrice(_):
            return .get
        case .deleteJob(_),.removeJobDetails(_):
            return .delete
        case .postShowDetails(_),.apply_job(_),.reject_job(_),.updateJobTask(_),.updatejobDetail(_),.saveTransectionData(_),.addJobDetail(_),.addRating(_),.finishJob(_),.updateShowingDetail(_),.cancelMyJob(_):
            return .post
        }
    }
    var task: HTTPTask {
        switch self {
        case .create_job(_),.deleteJob(_),.postShowDetails(_),.apply_job(_),.reject_job(_),.updateJobTask(_),.updatejobDetail(_),.saveTransectionData(_),.addJobDetail(_),.removeJobDetails(_),.addRating(_),.finishJob(_),.updateShowingDetail(_),.cancelMyJob(_):
            return .requestParameters(bodyParameters: parameters, bodyEncoding: ParameterEncoding.jsonEncoding, urlParameters: nil)
        case .getMyJob,.get_All_Jobs,.getJobDetails(_),.getAgentAvailability(_),.getAccountStatus,.getHireJobPrice(_),.getShowingDetails,.getShowJobPrice(_):
            return .request
            
        }
    }
    var headers: HTTPHeaders? {
        switch self {
        case .create_job(_),.getMyJob,.deleteJob(_),.postShowDetails(_),.get_All_Jobs,.apply_job(_),.reject_job(_),.updateJobTask(_),.updatejobDetail(_),.saveTransectionData(_),.getJobDetails(_),.addJobDetail(_),.removeJobDetails(_),.addRating(_),.finishJob(_),.getAgentAvailability(_),.getAccountStatus,.getHireJobPrice(_),.getShowingDetails,.getShowJobPrice(_),.updateShowingDetail(_),.cancelMyJob(_):
           return ["Authorization":UserStoreSingleton.shared.userToken ?? ""]
           
        }
    }
    var parameters: Parameters {
        switch self {
        case .create_job(let parameters),.deleteJob(let parameters),.postShowDetails(let parameters),.apply_job(let parameters),.reject_job(let parameters),.updateJobTask(let parameters),.updatejobDetail(let parameters),.saveTransectionData(let parameters),.addJobDetail(let parameters),.removeJobDetails(let parameters),.addRating(let parameters),.finishJob(let parameters),.updateShowingDetail(let parameters),.cancelMyJob(let parameters):
            return parameters
        case .getMyJob,.get_All_Jobs,.getJobDetails(_),.getAgentAvailability(_),.getAccountStatus,.getHireJobPrice(_),.getShowingDetails,.getShowJobPrice:
            return [:]
        }
    }
    
    var queryParametrs: [URLQueryItem] {
        switch self {
        case .getAgentAvailability(let query),.getHireJobPrice(let query),.getShowJobPrice(let query):
            return query
        default:
            return []
        }
    }
    
}
