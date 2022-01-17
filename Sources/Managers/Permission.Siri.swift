//
//  Permission.Siri.swift
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

import Intents

extension Provider {
    
    public static let siri: Provider = .init(SiriManager())
}

struct SiriManager: Permissionable {
    
    var status: PermissionStatus {
        if #available(iOS 10.0, *) {
            switch _status {
            case .authorized:       return .authorized
            case .denied:           return .denied
            case .restricted:       return .disabled
            case .notDetermined:    return .notDetermined
            @unknown default:       return .invalid
            }
        }
        return .denied
    }
    
    var name: String { return "Siri" }
    
    var usageDescriptions: [String] {
        return ["NSSiriUsageDescription"]
    }
    
    @available(iOS 10.0, *)
    private var _status: INSiriAuthorizationStatus {
        return INPreferences.siriAuthorizationStatus()
    }
    
    func request(_ сompletion: @escaping () -> Void) {
        guard status == .notDetermined else {
            сompletion()
            return
        }
        
        if #available(iOS 10.0, *) {
            INPreferences.requestSiriAuthorization { (status) in
                DispatchQueue.main.async {
                    сompletion()
                }
            }
            
        } else {
            сompletion()
        }
    }
}
