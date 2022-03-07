//
//  UserSingleTon.swift
//  Chores for me
//
//  Created by Bright_1 on 07/09/21.
//

import Foundation
import UIKit

class UserStoreSingleton: NSObject{
    static let shared = UserStoreSingleton()
    private override init() {}
    
    //  var userlat: Double?
    //  var userLong: Double?
   
    
    var jobId :Int?{
        get{
            return (UserDefaults().object(forKey: "jobId") as? Int)
        }set{
            UserDefaults.standard.setValue(newValue, forKey: "jobId")
        }
    }
    var id :Int?{
        get{
            return (UserDefaults().object(forKey: "id") as? Int)
        }set{
            UserDefaults.standard.setValue(newValue, forKey: "id")
        }
    }

    var userLong: Double? {
        get{
            return (UserDefaults().object(forKey: "userLong") as? Double)
        }set{
            UserDefaults.standard.setValue(newValue, forKey: "userLong")
        }
    }
    var userlat : Double?{
        get{
            return (UserDefaults().object(forKey: "userlat") as? Double)
        }set{
            UserDefaults.standard.setValue(newValue, forKey: "userlat")
        }
    }
    
    var isLoggedIn : Bool?{
        get{
            return (UserDefaults().object(forKey: "isLoggedIn") as? Bool)
        }set{
            UserDefaults.standard.setValue(newValue, forKey: "isLoggedIn")
        }
    }
    var isFromNotification : Bool?{
        get{
            return (UserDefaults().object(forKey: "isFromNotification") as? Bool)
        }set{
            UserDefaults.standard.setValue(newValue, forKey: "isFromNotification")
        }
    }
    var isLocationEnbled : Bool?{
        get{
            return (UserDefaults().object(forKey: "isLocationEnbled") as? Bool)
        }set{
            UserDefaults.standard.setValue(newValue, forKey: "isLocationEnbled")
        }
    }
    var userType : String?{
        get{
            return (UserDefaults().object(forKey: "userType") as? String)
        }set{
            UserDefaults.standard.setValue(newValue, forKey: "userType")
        }
    }
    var userToken : String?{
        get{
            return (UserDefaults().object(forKey: "userToken") as? String)
        }set{
            UserDefaults.standard.setValue(newValue, forKey: "userToken")
        }
    }
    var phoneNumer : String?{
        get{
            return (UserDefaults().object(forKey: "phoneNumer") as? String)
        }set{
            UserDefaults.standard.setValue(newValue, forKey: "phoneNumer")
        }
    }
    var socailphoneNumber : String?{
        get{
            return (UserDefaults().object(forKey: "phoneNumer") as? String)
        }set{
            UserDefaults.standard.setValue(newValue, forKey: "phoneNumer")
        }
    }
    var profileImage : String?{
        get{
            return (UserDefaults().object(forKey: "profileImage") as? String)
        }set{
            UserDefaults.standard.setValue(newValue, forKey: "profileImage")
        }
    }
    var socailProfileImage : String?{
        get{
            return (UserDefaults().object(forKey: "socailProfileImage") as? String)
        }set{
            UserDefaults.standard.setValue(newValue, forKey: "socailProfileImage")
        }
    }
    var name : String?{
        get{
            return (UserDefaults().object(forKey: "name") as? String)
        }set{
            UserDefaults.standard.setValue(newValue, forKey: "name")
        }
    }
    var lastname : String?{
        get{
            return (UserDefaults().object(forKey: "lastname") as? String)
        }set{
            UserDefaults.standard.setValue(newValue, forKey: "lastname")
        }
    }
    var userID : Int?{
        get{
            return (UserDefaults().object(forKey: "userID") as? Int)
        }set{
            UserDefaults.standard.setValue(newValue, forKey: "userID")
        }
    }
    var email : String?{
        get{
            return (UserDefaults().object(forKey: "email") as? String)
        }set{
            UserDefaults.standard.setValue(newValue, forKey: "email")
        }
    }
    
    var pass : String?{
        get{
            return (UserDefaults().object(forKey: "pass") as? String)
        }set{
            UserDefaults.standard.setValue(newValue, forKey: "pass")
        }
    }
    
    var OtpCode : String?{
        get{
            return (UserDefaults().object(forKey: "Otp") as? String)
        }set{
            UserDefaults.standard.setValue(newValue, forKey: "Otp")
        }
    }
    
    var currentLat : Double?{
        get{
            return (UserDefaults().object(forKey: "currentLat") as? Double)
        }set{
            UserDefaults.standard.setValue(newValue, forKey: "currentLat")
        }
    }
    var currentLong : Double?{
        get{
        return (UserDefaults().object(forKey: "currentLong") as? Double)
        }set{
            UserDefaults.standard.setValue(newValue, forKey: "currentLong")
        }
    }
    var bookingID : Int?{
        get{
            return (UserDefaults().object(forKey: "bookingID") as? Int)
        }set{
            UserDefaults.standard.setValue(newValue, forKey: "bookingID")
        }
    }
    
    var fcmToken : String?{
        get{
            return (UserDefaults().object(forKey: "fcmToken") as? String)
        }set{
            UserDefaults.standard.setValue(newValue, forKey: "fcmToken")
        }
    }
    var Token : String?{
        get{
            return (UserDefaults().object(forKey: "Token") as? String)
        }set{
            UserDefaults.standard.setValue(newValue, forKey: "Token")
        }
    }
    
    var userRating : Double?{
        get{
            return (UserDefaults().object(forKey: "userRating") as? Double)
        }set{
            UserDefaults.standard.setValue(newValue, forKey: "userRating")
        }
    }
    var PostalCode : String?{
        get{
            return (UserDefaults().object(forKey: "PostalCode") as? String)
        }set{
            UserDefaults.standard.setValue(newValue, forKey: "PostalCode")
        }
    }
    
    var Address : String?{
        get{
            return (UserDefaults().object(forKey: "Address") as? String)
        }set{
            UserDefaults.standard.setValue(newValue, forKey: "Address")
        }
    }
    var locationName : String?{
        get{
            return (UserDefaults().object(forKey: "locationName") as? String)
        }set{
            UserDefaults.standard.setValue(newValue, forKey: "locationName")
        }
    }

    var realEstateLicenseNumber : String?{
        get{
            return (UserDefaults().object(forKey: "realEstateLicenseNumber") as? String)
        }set{
            UserDefaults.standard.setValue(newValue, forKey: "realEstateLicenseNumber")
        }
    }
    var mailingAddress : String?{
        get{
            return (UserDefaults().object(forKey: "mailingAddress") as? String)
        }set{
            UserDefaults.standard.setValue(newValue, forKey: "mailingAddress")
        }
    }
    var is24HourFormat : Bool?{
        get{
            return (UserDefaults().object(forKey: "is24HourFormat") as? Bool)
        }set{
            UserDefaults.standard.setValue(newValue, forKey: "is24HourFormat")
        }
    }
    var appleEmail : String?{
        get{
            return (UserDefaults().object(forKey: "appleEmail") as? String)
        }set{
            UserDefaults.standard.setValue(newValue, forKey: "appleEmail")
        }
    }
    var brokerageType : String?{
        get{
            return (UserDefaults().object(forKey: "brokerageType") as? String)
        }set{
            UserDefaults.standard.setValue(newValue, forKey: "brokerageType")
        }
    }
    var providerId : Int?{
        get{
            return (UserDefaults().object(forKey: "providerId") as? Int)
        }set{
            UserDefaults.standard.setValue(newValue, forKey: "providerId")
        }
    }
    var categeoryName : String?{
        get{
            return(UserDefaults().object(forKey: "categeoryName") as? String)
        }set{
            UserDefaults.standard.setValue(newValue, forKey: "categeoryName")
        }
    }
    var categeory : String?{
        get{
            return(UserDefaults().object(forKey: "categeory") as? String)
        }set{
            UserDefaults.standard.setValue(newValue, forKey: "categeory")
        }
    }
    var categeoryID : Int?{
        get{
            return(UserDefaults().object(forKey: "categeoryID") as? Int)
        }set{
            UserDefaults.standard.setValue(newValue, forKey: "categeoryID")
        }
    }
    var subCategeoryID : Int?{
        get{
            return(UserDefaults().object(forKey: "subCategeoryID") as? Int)
        }set{
            UserDefaults.standard.setValue(newValue, forKey: "subCategeoryID")
        }
    }
    var SubCategeoryName : String?{
        get{
            return(UserDefaults().object(forKey: "SubCategeoryName") as? String)
        }set{
            UserDefaults.standard.setValue(newValue, forKey: "SubCategeoryName")
        }
    }
    var Dialcode : String?{
        get{
            return(UserDefaults().object(forKey: "Dialcode") as? String)
        }set{
            UserDefaults.standard.setValue(newValue, forKey: "Dialcode")
        }
    }
    
    
    
}


