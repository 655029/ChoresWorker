//
//  Navigation.swift
//  Chores for me
//
//  Created by Chores for me 2021 on 14/04/21.
//

import UIKit

enum Navigation: Navigatable {
    case login
    case allowLocation
    case register
    case twosetpVerification
    case forgotPassword
    case forgotPasswordOTP
    case resetPassword
    case chooseYourCity
    case chooseLocationOnMap
    case chooseService
    case chooseSubService(service: Service)
    case uploadProfilePicture
    case selectAvailability
    case uploadIDProof
    case jobStatus(jobId: Int)
    case cancelJobRequest(jobId:Int,user_id:Int)
    case notifications
    case logout(image:UIImage)
    case jobstatus
    case choresID
    case editProfile
    case confirmJob
    case newBooking
    case advanceBooking
    case googleLogin
    case facebookLogin
}

struct AppNavigation: AppNavigatable {
    
    func viewcontrollerForNavigation(navigation: Navigatable) -> UIViewController {
        if let navigation = navigation as? Navigation {
            switch navigation {
            case .login:
                return Storyboard.Authentication.viewController(for: LoginViewController.self)
            case .allowLocation:
                return Storyboard.Authentication.viewController(for: AllowLocationViewController.self)
            case .register:
                return Storyboard.Authentication.viewController(for: RegisterViewController.self)
            case .twosetpVerification:
                return Storyboard.Authentication.viewController(for: TwoStepVerificationViewController.self)
            case .forgotPassword:
                return Storyboard.Authentication.viewController(for: ForgotPasswordViewController.self)
            case .forgotPasswordOTP:
                return Storyboard.Authentication.viewController(for: ForgotPasswordOTPViewController.self)
            case .resetPassword:
                return Storyboard.Authentication.viewController(for: ResetPasswordViewController.self)
            case .chooseYourCity:
                return Storyboard.Location.viewController(for: ChooseYourCityViewController.self)
            case .chooseLocationOnMap:
                return ChooseLocationFromMapViewController()
            case .chooseService:
                return Storyboard.Service.viewController(for: ChooseYourServiceViewController.self)
            case .chooseSubService(service: let service):
                let vc = Storyboard.Service.viewController(for: ChooseSubServicesViewController.self)
                vc.service = service
                return vc
            case.selectAvailability:
                return Storyboard.Profile.viewController(for: SelectAvailabilityViewController.self)
            case .uploadProfilePicture:
                return Storyboard.Profile.viewController(for: UploadProfilePictureViewController.self)
            case .uploadIDProof:
                return Storyboard.Profile.viewController(for: UploadIDProofViewController.self)
                
            case .jobStatus(jobId: let jobId):
                let vc = Storyboard.Booking.viewController(for: BookingJobStatusViewController.self)
                vc.jobId = jobId
                return vc

            case .cancelJobRequest(jobId: let jobid, user_id: let user_id):
                let vc = Storyboard.Booking.viewController(for: CancelRequestViewController.self)
                vc.jobId = jobid
                vc.userId = user_id
                return vc
            case .notifications:
                return Storyboard.Profile.viewController(for: NotificationsViewController.self)
            case .logout(image: let image):
                let vc = Storyboard.Profile.viewController(for: LogoutViewController.self)
                vc.image = image
                return vc
            
//            case .logout:
//                return Storyboard.Profile.viewController(for: LogoutViewController.self)
            case .choresID:
                return Storyboard.Profile.viewController(for: ChoresIDViewController.self)
            case .jobstatus:
                return Storyboard.Profile.viewController(for: ChoresIDViewController.self)
            case .editProfile:
                return Storyboard.Profile.viewController(for: EditProfileViewController.self)
            case .confirmJob:
                return Storyboard.Booking.viewController(for: ConfirmJobViewController.self)
            case .newBooking:
                return Storyboard.Booking.viewController(for: NewBookingViewController.self)
            case .advanceBooking:
                return Storyboard.Booking.viewController(for: BookingsViewController.self)
                case .googleLogin:
                    return Storyboard.Authentication.viewController(for: GoogleSignUpViewController.self)
                case .facebookLogin:
                    return Storyboard.Authentication.viewController(for: FacebookSignUpViewController.self)
            }
        }else {
            // FIXME: Implement other `Navigation`
            fatalError("Implement")
        }
    }
    
    func navigate(_ navigation: Navigatable, from: UIViewController, to: UIViewController) {
        from.navigationController?.pushViewController(to, animated: false)
    }
}

extension UIViewController {
    
    func navigate(_ navigation: Navigation) {
        navigate(navigation as Navigatable)
    }
}
