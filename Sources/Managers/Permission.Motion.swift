//
//  Permission.Motion.swift
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

import CoreMotion

extension Provider {
    
    public static let motion: Provider = .init(MotionManager())
}

struct MotionManager: Permissionable {
    
    var status: PermissionStatus {
        if #available(iOS 11.0, *) {
            switch _status {
            case .authorized:       return .authorized
            case .denied:           return .denied
            case .restricted:       return .disabled
            case .notDetermined:    return .notDetermined
            @unknown default:       return .invalid
            }
        }
        return .invalid
    }
    
    var name: String { return "Motion" }
    
    var usageDescriptions: [String] {
        return ["NSMotionUsageDescription"]
    }
    
    @available(iOS 11.0, *)
    private var _status: CMAuthorizationStatus {
        return CMMotionActivityManager.authorizationStatus()
    }
    
    func request(_ сompletion: @escaping () -> Void) {
        guard status == .notDetermined else {
            сompletion()
            return
        }
        
        let manager = CMMotionActivityManager()
        let today = Date()
        
        manager.queryActivityStarting(from: today, to: today, to: .main) {
            (activities: [CMMotionActivity]?, error: Error?) in
            сompletion()
            manager.stopActivityUpdates()
        }
    }
}
