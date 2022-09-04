import Foundation
enum NetworkEnvironment {
    case qa
    case production
    case staging
}

struct ApiConstants {
    struct ProductionServer {
        static let baseURL = "http://52.14.21.106:5000/api/v1/"
        static let stripeKey = "sk_test_51JCLMyHh3ZULRx65OSYIbPrAhjqyOaOvCndsIiICJvZX0jqtjcWxE4EHPg8E6dXnG9M0bOsaELqm4UpirIoeYJAh00948ptNbt"
    
        static let socketUrl = "http://3.128.96.192:3000/"
        static let googleAPIKey = "AIzaSyAhf8sFM5w1kXAYtzK98lpxqIfPy5FbFMs"
        static let memberAgreementUrl = "http://3.128.96.192:3000/api/v1/get-user-license-agreement"
        static let privacyUrl = "http://3.128.96.192:3000/api/v1/get-privacy-policy"
    }
    struct qAserver {
        //   static let stripeKey = "pk_test_51H6yFaEtA2Qvqf56aSP66D9V40pDmw0MhWaGdaY6OPNlf7EHCfNQRYeVTaswVlJwtDoE4DhzBA6FBnfX74HIscs300tBKORlnu"
        static let baseURL = "http://52.14.21.106:5000/api/v1/"
    }
}

enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
}

enum ContentType: String {
    case json = "application/json"
}
