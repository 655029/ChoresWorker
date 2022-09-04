//
//  Storyboard.swift
//  Chores for me
//
//  Created by Chores for me 2019 on 14/04/21.
//

import Foundation
import UIKit

struct Storyboard {
    static let Authentication: UIStoryboard = UIStoryboard(name: "Authentication", bundle: nil)
    static let LaunchScreen: UIStoryboard = UIStoryboard(name: "LaunchScreen", bundle: nil)
    static let Splash: UIStoryboard = UIStoryboard(name: "Splash", bundle: nil)
    static let Main: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    static let Location: UIStoryboard = UIStoryboard(name: "Location", bundle: nil)
    static let Service: UIStoryboard = UIStoryboard(name: "Service", bundle: nil)
    static let Profile: UIStoryboard = UIStoryboard(name: "Profile", bundle: nil)
    static let Home: UIStoryboard = UIStoryboard(name: "Home", bundle: nil)
    static let Booking: UIStoryboard = UIStoryboard(name: "Booking", bundle: nil)
    static let Menu: UIStoryboard = UIStoryboard(name: "Menu", bundle: nil)
}

extension UIStoryboard {

    public func viewController<T: UIViewController>(for type: T.Type, withIdentifier identifier: String? = nil) -> T {
        guard let viewController = self.instantiateViewController(withIdentifier: identifier ?? String(describing: T.self)) as? T else { fatalError("Storyboard ID is missing or wrong") }
        return viewController
    }
}
