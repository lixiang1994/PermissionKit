//
//  SystemAlert.swift
//  ┌─┐      ┌───────┐ ┌───────┐
//  │ │      │ ┌─────┘ │ ┌─────┘
//  │ │      │ └─────┐ │ └─────┐
//  │ │      │ ┌─────┘ │ ┌─────┘
//  │ └─────┐│ └─────┐ │ └─────┐
//  └───────┘└───────┘ └───────┘
//
//  Created by lee on 2019/6/3.
//  Copyright © 2019年 lee. All rights reserved.
//

import UIKit

public class SystemAlert: PermissionAlertable {
    
    private let source: PermissionAlertContentSource
    
    public var isPrepare = true
    public var isDenied = true
    public var isDisabled = true
    
    required public init(_ source: PermissionAlertContentSource = DefaultAlertContent()) {
        self.source = source
    }
    
    public func show(_ status: AlertStatus, with сompletion: @escaping (Bool) -> Void) {
        switch status {
        case .prepare:
            showPrepare(status, сompletion)
            
        case .denied:
            showDenied(status, сompletion)
            
        case .disabled:
            showDisabled(status, сompletion)
        }
    }
    
    private func showPrepare(_ status: AlertStatus, _ сompletion: @escaping (Bool) -> Void) {
        guard isPrepare else {
            сompletion(true)
            return
        }
        
        let title   = source.title(status)
        let message = source.message(status)
        let cancel  = source.cancelAction(status)
        let confirm = source.confirmAction(status)
        
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        do {
            let action = UIAlertAction(title: cancel, style: .cancel) { _ in
                сompletion(false)
            }
            controller.addAction(action)
        }
        do {
            let action = UIAlertAction(title: confirm, style: .default) { _ in
                сompletion(true)
            }
            controller.addAction(action)
        }
        UIViewController.top?.present(controller, animated: true)
    }
    
    private func showDenied(_ status: AlertStatus, _ сompletion: @escaping (Bool) -> Void) {
        guard isDenied else {
            сompletion(false)
            return
        }
        
        let title   = source.title(status)
        let message = source.message(status)
        let cancel  = source.cancelAction(status)
        let confirm = source.confirmAction(status)
        
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        do {
            let action = UIAlertAction(title: cancel, style: .cancel) { _ in
                сompletion(false)
            }
            controller.addAction(action)
        }
        do {
            let action = UIAlertAction(title: confirm, style: .default) { _ in
                guard let url = URL(string: UIApplication.openSettingsURLString) else {
                    сompletion(false)
                    return
                }
                
                var object: Any?
                object = NotificationCenter.default.addObserver(
                    forName: UIApplication.didBecomeActiveNotification,
                    object: nil,
                    queue: .main,
                    using: { _ in
                        NotificationCenter.default.removeObserver(object ?? 0)
                        DispatchQueue.main.async {
                            сompletion(true)
                        }
                    }
                )
                
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url)
                    
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
            controller.addAction(action)
        }
        UIViewController.top?.present(controller, animated: true)
    }
    
    private func showDisabled(_ status: AlertStatus, _ сompletion: @escaping (Bool) -> Void) {
        guard isDisabled else {
            сompletion(false)
            return
        }
        
        let title   = source.title(status)
        let message = source.message(status)
        let cancel  = source.cancelAction(status)
        
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: cancel, style: .cancel) { _ in
            сompletion(false)
        }
        controller.addAction(action)
        UIViewController.top?.present(controller, animated: true)
    }
}

// MARK: - UIViewController
fileprivate extension UIViewController {
    
    static var top: UIViewController? {
        let window = UIApplication.shared.windows.first {
            $0.rootViewController != nil && $0.isKeyWindow
        }
        return self.topMost(of: window?.rootViewController)
    }
    
    private static func topMost(of viewController: UIViewController?) -> UIViewController? {
        // presented view controller
        if let presentedViewController = viewController?.presentedViewController {
            return self.topMost(of: presentedViewController)
        }
        
        // UITabBarController
        if let tabBarController = viewController as? UITabBarController,
            let selectedViewController = tabBarController.selectedViewController {
            return self.topMost(of: selectedViewController)
        }
        
        // UINavigationController
        if let navigationController = viewController as? UINavigationController,
            let visibleViewController = navigationController.visibleViewController {
            return self.topMost(of: visibleViewController)
        }
        
        // UIPageController
        if let pageViewController = viewController as? UIPageViewController,
            pageViewController.viewControllers?.count == 1 {
            return self.topMost(of: pageViewController.viewControllers?.first)
        }
        
        // child view controller
        for subview in viewController?.view?.subviews ?? [] {
            if let childViewController = subview.next as? UIViewController {
                return self.topMost(of: childViewController)
            }
        }
        
        return viewController
    }
}
