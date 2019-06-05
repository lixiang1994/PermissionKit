//
//  Permission+Notification.swift
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

import UserNotifications

extension Permission {
    
    public static let notification: Provider = .init(NotificationManager())
}

struct NotificationManager: Permissionable {
    
    @available(iOS 10.0, *)
    private static var status: UNAuthorizationStatus?
    @available(iOS 10.0, *)
    private static let observer: Void = {
        NotificationCenter.default.addObserver(
            forName: UIApplication.willEnterForegroundNotification,
            object: nil,
            queue: .main,
            using: { _ in
                status = nil
                UNUserNotificationCenter.current().getNotificationSettings { value in
                    DispatchQueue.main.async {
                        status = value.authorizationStatus
                    }
                }
            }
        )
    } ()
    
    init() {
        if #available(iOS 10.0, *) {
            NotificationManager.observer
        }
    }
    
    var status: Permission.Status {
        if #available(iOS 10.0, *) {
            switch _status {
            case .authorized, .provisional:     return .authorized
            case .denied:                       return .denied
            case .notDetermined:                return .notDetermined
            @unknown default:                   return .invalid
            }
            
        } else {
            let settings = UIApplication.shared.currentUserNotificationSettings
            let types = settings?.types ?? []
            let isRequested = UserDefaults.standard.isRequestedNotifications
            return types.isEmpty ? (isRequested ? .denied : .notDetermined) : .authorized
        }
    }
    
    var name: String { return "Notification" }
    
    var usageDescriptions: [String] {
        return []
    }
    
    @available(iOS 10.0, *)
    private var _status: UNAuthorizationStatus {
        guard let status = NotificationManager.status else {
            var settings: UNNotificationSettings?
            let semaphore = DispatchSemaphore(value: 0)
            DispatchQueue.global().async {
                UNUserNotificationCenter.current().getNotificationSettings { value in
                    settings = value
                    semaphore.signal()
                }
            }
            semaphore.wait()
            NotificationManager.status = settings?.authorizationStatus
            return NotificationManager.status ?? .denied
        }
        return status
    }
    
    func request(_ сompletion: @escaping () -> Void) {
        guard status == .notDetermined else {
            сompletion()
            return
        }
        
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.badge, .alert, .sound]) {
                (granted, error) in
                center.getNotificationSettings { value in
                    DispatchQueue.main.async {
                        NotificationManager.status = value.authorizationStatus
                        сompletion()
                    }
                }
            }
            
        } else {
            var object: Any?
            object = NotificationCenter.default.addObserver(
                forName: UIApplication.didBecomeActiveNotification,
                object: nil,
                queue: .main,
                using: { _ in
                    NotificationCenter.default.removeObserver(object ?? 0)
                    UserDefaults.standard.isRequestedNotifications = true
                    DispatchQueue.main.async {
                        сompletion()
                    }
                }
            )
            
            let settings = UIUserNotificationSettings(
                types: [.badge, .sound, .alert],
                categories: nil
            )
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
        
        UIApplication.shared.registerForRemoteNotifications()
    }
}

fileprivate extension UserDefaults {
    
    var isRequestedNotifications: Bool {
        get { return bool(forKey: "Permission.RequestedNotifications") }
        set { set(newValue, forKey: "Permission.RequestedNotifications") }
    }
}
