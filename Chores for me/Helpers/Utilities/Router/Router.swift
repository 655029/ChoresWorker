//
//  Router.swift
//  Chores for me
//
//  Created by Chores for me 2021 on 14/04/21.
//

import UIKit

public class Router {
    public static let `default`:IsRouter = DefaultRouter()
}

public protocol Navigatable { }

public protocol AppNavigatable {
    func viewcontrollerForNavigation(navigation: Navigatable) -> UIViewController
    func navigate(_ navigation: Navigatable, from: UIViewController, to: UIViewController)
}

public protocol IsRouter {
    func setupAppNavigation(appNavigation: AppNavigatable)
    func navigate(_ navigation: Navigatable, from: UIViewController)
    func didNavigate(block: @escaping (Navigatable) -> Void)
    var appNavigation: AppNavigatable? { get }
}

public extension UIViewController {
    func navigate(_ navigation: Navigatable) {
        Router.default.navigate(navigation, from: self)
    }
}

public class DefaultRouter: IsRouter {
    
    public var appNavigation: AppNavigatable?
    var didNavigateBlocks = [((Navigatable) -> Void)] ()
    
    public func setupAppNavigation(appNavigation: AppNavigatable) {
        self.appNavigation = appNavigation
    }
    
    public func navigate(_ navigation: Navigatable, from: UIViewController) {
        if let toVC = appNavigation?.viewcontrollerForNavigation(navigation: navigation) {
            appNavigation?.navigate(navigation, from: from, to: toVC)
            for b in didNavigateBlocks {
                b(navigation)
            }
        }
    }
    
    public func didNavigate(block: @escaping (Navigatable) -> Void) {
        didNavigateBlocks.append(block)
    }
}

// Injection helper
public protocol Initializable { init() }
open class RuntimeInjectable: NSObject, Initializable {
    public required override init() {}
}

public func appNavigationFromString(_ appNavigationClassString: String) -> AppNavigatable {
    let appNavClass = NSClassFromString(appNavigationClassString) as! RuntimeInjectable.Type
    let appNav = appNavClass.init()
    return appNav as! AppNavigatable
}
