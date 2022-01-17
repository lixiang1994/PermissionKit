//
//  Permission.Event.swift
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

import EventKit

extension Provider {
    
    public static let calendar: Provider = .init(CalendarManager())
    
    public static let reminder: Provider = .init(ReminderManager())
}

struct CalendarManager: Permissionable {
    
    var status: PermissionStatus {
        switch _status {
        case .authorized:       return .authorized
        case .denied:           return .denied
        case .restricted:       return .disabled
        case .notDetermined:    return .notDetermined
        @unknown default:       return .invalid
        }
    }
    
    var name: String { return "Calendar" }
    
    var usageDescriptions: [String] {
        return ["NSCalendarsUsageDescription"]
    }
    
    private var _status: EKAuthorizationStatus {
        return EKEventStore.authorizationStatus(for: .event)
    }
    
    func request(_ сompletion: @escaping () -> Void) {
        guard status == .notDetermined else {
            сompletion()
            return
        }
        
        let store = EKEventStore()
        store.requestAccess(to: .event) { (granted: Bool, error: Error?) in
            DispatchQueue.main.async {
                сompletion()
            }
        }
    }
}

struct ReminderManager: Permissionable {
    
    var status: PermissionStatus {
        switch _status {
        case .authorized:       return .authorized
        case .denied:           return .denied
        case .restricted:       return .disabled
        case .notDetermined:    return .notDetermined
        @unknown default:       return .invalid
        }
    }
    
    var name: String { return "Reminder" }
    
    var usageDescriptions: [String] {
        return ["NSRemindersUsageDescription"]
    }
    
    private var _status: EKAuthorizationStatus {
        return EKEventStore.authorizationStatus(for: .reminder)
    }
    
    func request(_ сompletion: @escaping () -> Void) {
        guard status == .notDetermined else {
            сompletion()
            return
        }
        
        let store = EKEventStore()
        store.requestAccess(to: .reminder) { (granted: Bool, error: Error?) in
            DispatchQueue.main.async {
                сompletion()
            }
        }
    }
}
