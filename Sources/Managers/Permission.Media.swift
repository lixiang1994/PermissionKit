//
//  Permission.Media.swift
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

import MediaPlayer

extension Provider {
    
    public static let media: Provider = .init(MediaManager())
}

struct MediaManager: Permissionable {
    
    var status: PermissionStatus {
        if #available(iOS 9.3, *) {
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
    
    var name: String { return "Media Library" }
    
    var usageDescriptions: [String] {
        return ["NSAppleMusicUsageDescription"]
    }
    
    @available(iOS 9.3, *)
    private var _status: MPMediaLibraryAuthorizationStatus {
        return MPMediaLibrary.authorizationStatus()
    }
    
    func request(_ сompletion: @escaping () -> Void) {
        guard status == .notDetermined else {
            сompletion()
            return
        }
        
        if #available(iOS 9.3, *) {
            MPMediaLibrary.requestAuthorization() { status in
                DispatchQueue.main.async {
                    сompletion()
                }
            }
            
        } else {
            сompletion()
        }
    }
}
