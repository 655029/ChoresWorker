

import Foundation

enum AuthenticationEndPoint {
    case login(Parameters)
    case signUp(Parameters)
    case consumerBooking(Parameters)
    case savePayment(Parameters)
    case getBookingWithQr(Parameters)
    case socialSignIn(Parameters)
    case uploadFile(Parameters)
    case verifyOtp(Parameters)
    case sendOtp(Parameters)
    case resetPassowrd(Parameters)
    case upload(Parameters)
    case getUserProfile
    case getWelcomeScreen
    case getConsumer
  //  case saveConsumerProfile
    case update_Profile(Parameters)
    case saveCustomerProfile(Parameters)
    case updateMytoken(Parameters)
    case resendOtp(Parameters)
    case updatePhone(Parameters)
    case update_online_status(Parameters)
}


extension AuthenticationEndPoint: EndPointType {
    var queryParametrs: [URLQueryItem] {
        return []
    }
    

    var baseURL: URL {
        guard let url = URL(string: ApiConstants.ProductionServer.baseURL) else { fatalError("baseURL could not be configured.")}
        return url
    }

    var path: String {
        switch self {
        case .login(_):
            return "login"
        case .signUp(_):
            return "signup"
        case .getBookingWithQr(_):
            return "get-booking-data-by-qr-code"
        case .uploadFile(_):
            return "upload"
        case .upload(_):
            return "upload"
        case .verifyOtp(_):
            return "verify-otp"
        case .sendOtp(_):
            return "send-otp"
        case .consumerBooking(_):
            return "create-booking"
        case .saveCustomerProfile(_):
            return "save-consumer-profile"
        case .getConsumer:
            return "get-consumer-profile"
        case .savePayment(_):
            return "save-payment-data"
        case .resetPassowrd(_):
            return "reset-password"
        case .getUserProfile:
            return "user-profile"
        case .getWelcomeScreen:
            return "welcome-screen-data"
        case .update_Profile(_):
            return "update-profile"
        case .updateMytoken(_):
            return "update-token"
        case .socialSignIn(_):
            return "social-login"
        case .resendOtp(_):
            return "send-otp"
        case .updatePhone(_):
            return "update-phone"
        case .update_online_status(_):
            return "update-online-status"
        }

    }

    var httpMethod: HTTPMethod {
        switch self {
        case .login(_):
            return .post
        case .signUp(_):
            return .post
        case .uploadFile(_):
            return .post
        case .verifyOtp(_),.sendOtp(_),.resetPassowrd(_),.update_Profile(_),.updateMytoken(_),.socialSignIn(_),.resendOtp(_),.updatePhone(_),.update_online_status(_),.consumerBooking(_),.saveCustomerProfile(_),.savePayment(_),.getBookingWithQr(_),.upload(_):
            return .post
        case .getUserProfile,.getWelcomeScreen,.getConsumer:
            return .get
        }
    }

    var task: HTTPTask {
        switch self {
        case .login(_):
            return .requestParameters(bodyParameters: parameters, bodyEncoding: ParameterEncoding.jsonEncoding, urlParameters: nil)
        case .signUp(_):
            return .requestParameters(bodyParameters: parameters, bodyEncoding: ParameterEncoding.jsonEncoding, urlParameters: nil)
        case .uploadFile(_):
            return .requestParametersWithFile(bodyParameters: parameters, bodyEncoding: ParameterEncoding.jsonEncoding, urlParameters: nil)
        case .upload(_):
            return .requestParametersWithFile(bodyParameters: parameters, bodyEncoding: ParameterEncoding.jsonEncoding, urlParameters: nil)
        case .verifyOtp(_),.sendOtp(_),.resetPassowrd(_),.update_Profile(_),.updateMytoken(_),.socialSignIn(_),.resendOtp(_),.updatePhone(_),.update_online_status(_),.consumerBooking(_),.saveCustomerProfile(_),.savePayment(_),.getBookingWithQr(_):
            return .requestParameters(bodyParameters: parameters, bodyEncoding: ParameterEncoding.jsonEncoding, urlParameters: nil)
        case .getUserProfile,.getWelcomeScreen,.getConsumer:
            return .request
        }
    }

    var headers: HTTPHeaders? {
        switch self {
        case .login(_),.socialSignIn(_),.upload(_):
            return nil
        case .signUp(_),.verifyOtp(_),.resetPassowrd(_),.resendOtp(_):
            return nil
        case .uploadFile(_):
            return nil
        case .getUserProfile,.getWelcomeScreen,.update_Profile(_),.updateMytoken(_),.sendOtp(_),.updatePhone(_),.update_online_status(_),.consumerBooking(_),.getConsumer,.saveCustomerProfile(_),.savePayment(_),.getBookingWithQr(_):
            return ["Authorization":UserStoreSingleton.shared.userToken ?? ""]
        }
    }

    var parameters: Parameters {
        switch self {
        case .login(let parameters):
            return parameters
        case .signUp(let parameters),.verifyOtp(let parameters),.sendOtp(let parameters),.resetPassowrd(let parameters),.update_Profile(let parameters),.getBookingWithQr(let parameters),.socialSignIn(let parameters),.resendOtp(let parameters),.updatePhone(let parameters),.update_online_status(let parameters),.consumerBooking(let parameters),.saveCustomerProfile(let parameters),.savePayment(let parameters),.upload(let parameters):
            return parameters
        case .uploadFile(let parameters),.updateMytoken(let parameters):
            return parameters
        case .getUserProfile,.getWelcomeScreen,.getConsumer:
            return [:]
        }
    }
}




