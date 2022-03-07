//
//  ChatEndPoints.swift
//  ShowAide
//
//  Created by Mohini's Macbook on 22/10/20.
//  Copyright © 2020 BrightRootsMohini. All rights reserved.
//

import Foundation
import UIKit

enum ChatEndPoint {
    case getChatInboxUser
    case getChatMessages(_ queryParams : [URLQueryItem])
    case deleteMessages(_ params : Parameters)
    case muteChat(_ params : Parameters)
    case getBlockStatus(_ roomId : Int)
}

extension ChatEndPoint: EndPointType {
    var baseURL: URL {
        guard let url = URL(string: ApiConstants.ProductionServer.baseURL) else { fatalError("baseURL could not be configured.")}
        return url
    }
    var path: String {
        switch self {
        case .getChatInboxUser:
            return "get-user-list"
        case .getChatMessages:
            return "get-user-chats"
        case .deleteMessages(_):
            return "delete-messages"
        case.muteChat(_):
            return "block-mute"
        case .getBlockStatus(let roomID):
            return "get-block-status/"+"\(roomID)"
        }
    }
    var httpMethod: HTTPMethod {
        switch self {
        case .getChatInboxUser,.getChatMessages(_),.getBlockStatus(_):
            return .get
        case .deleteMessages(_):
            return .delete
        case .muteChat(_):
            return .post
        }
    }
    var task: HTTPTask {
        switch self {
        case .getChatInboxUser,.getChatMessages(_),.getBlockStatus(_):
            return .request
        case .deleteMessages(let params),.muteChat(let params):
            return .requestParameters(bodyParameters: params, bodyEncoding: ParameterEncoding.jsonEncoding, urlParameters: nil)
        }
    }
    var headers: HTTPHeaders? {
        return ["Authorization":UserStoreSingleton.shared.userToken ?? ""]
    }
    var parameters: Parameters {
        switch self {
        case .getChatInboxUser,.getChatMessages(_),.getBlockStatus(_):
            return [:]
        case .deleteMessages(let params),.muteChat(let params):
           return params
        }
    }
    var queryParametrs: [URLQueryItem] {
        switch self {
        case .getChatInboxUser:
            return []
        case .getChatMessages(let query):
            return query
        case .deleteMessages,.muteChat(_),.getBlockStatus(_):
            return []
        }
    }
}
