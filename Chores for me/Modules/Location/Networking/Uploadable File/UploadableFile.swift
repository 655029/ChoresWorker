

import Foundation

enum MediaType: String {
    case audio = "audios"
    case video = "videos"
    case image = "images"
    case live  = "lives"
    case other = "others"
    
    static func parse(_ value: String) -> MediaType? {
        switch value.lowercased() {
        case audio.rawValue:
            return .audio
        case video.rawValue:
            return .video
        case image.rawValue:
            return .image
        case live.rawValue:
            return .live
        case other.rawValue:
            return .other
        default:
            return nil
        }
    }
}

public struct UploadableFile {
    
    enum FileType {
        case video
        case audio
        case image
        case gif
        
        var mimyType: String {
            switch self {
            case .image:
                return "image/*"
            case .audio:
                return "audio"
            case .video:
                return "video"
            case .gif:
                return "image/gif"
            }
        }
    }
    
    var type: FileType
    var data: Data
    var param: String
    
    var fileName: String {
        switch type {
        case .image:
            return UUID().uuidString + ".jpeg"
        case .video:
            return UUID().uuidString + ".mp4"
        case .audio:
            return UUID().uuidString + ".mp3"
        case .gif:
            return UUID().uuidString + ".gif"
        }
    }
}
