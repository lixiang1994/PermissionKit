//
//  Permission.Notification.swift
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

extension Provider {
    
    public struct NotificationOptions : OptionSet {
        
        public typealias RawValue = UInt
        
        public var rawValue: RawValue
        
        public init(rawValue: RawValue) {
            self.rawValue = rawValue
        }

        public static var badge: NotificationOptions { .init(rawValue: 1) }

        public static var sound: NotificationOptions { .init(rawValue: 2) }

        public static var alert: NotificationOptions { .init(rawValue: 4) }

        public static var carPlay: NotificationOptions { .init(rawValue: 8) }

        //available(iOS 12.0, *)
        public static var criticalAlert: NotificationOptions { .init(rawValue: 16) }

        //available(iOS 12.0, *)
        public static var providesAppNotificationSettings: NotificationOptions { .init(rawValue: 32) }

        //available(iOS 12.0, *)
        public static var provisional: NotificationOptions { .init(rawValue: 64) }

        //available(iOS 13.0, *)
        public static var announcement: NotificationOptions { .init(rawValue: 128) }
    }
    
    public static func notification(_ options: NotificationOptions) -> Provider {
        return .init(NotificationManager(options))
    }
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
    
    private let options: Provider.NotificationOptions
    
    init(_ options: Provider.NotificationOptions) {
        self.options = options
        
        if #available(iOS 10.0, *) {
            NotificationManager.observer
        }
    }
    
    var status: PermissionStatus {
        if #available(iOS 10.0, *) {
            switch _status {
            case .authorized, .provisional, .ephemeral:     return .authorized
            case .denied:                                   return .denied
            case .notDetermined:                            return .notDetermined
            @unknown default:                               return .invalid
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
        defer {
            UIApplication.shared.registerForRemoteNotifications()
        }
        guard status == .notDetermined else {
            сompletion()
            return
        }
        
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: options.options) {
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
                types: options.types,
                categories: nil
            )
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
    }
}

fileprivate extension UserDefaults {
    
    var isRequestedNotifications: Bool {
        get { return bool(forKey: "Permission.RequestedNotifications") }
        set { set(newValue, forKey: "Permission.RequestedNotifications") }
    }
}

private extension Provider.NotificationOptions {
    
    @available(iOS 10.0, *)
    var options: UNAuthorizationOptions {
        .init(rawValue: rawValue)
    }
    
    var types: UIUserNotificationType {
        .init(rawValue: rawValue)
    }
}
