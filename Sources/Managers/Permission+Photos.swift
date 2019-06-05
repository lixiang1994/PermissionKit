//
//  Permission+Photos.swift
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

import Photos

extension Permission {
    
    public static let photos: Provider = .init(PhotosManager())
}

struct PhotosManager: Permissionable {
    
    var status: Permission.Status {
        switch _status {
        case .authorized:       return .authorized
        case .denied:           return .denied
        case .restricted:       return .disabled
        case .notDetermined:    return .notDetermined
        @unknown default:       return .invalid
        }
    }
    
    var name: String { return "Photo Library" }
    
    var usageDescriptions: [String] {
        return ["NSPhotoLibraryUsageDescription"]
    }
    
    private var _status: PHAuthorizationStatus {
        return PHPhotoLibrary.authorizationStatus()
    }
    
    func request(_ сompletion: @escaping () -> Void) {
        guard status == .notDetermined else {
            сompletion()
            return
        }
        
        PHPhotoLibrary.requestAuthorization { finished in
            DispatchQueue.main.async {
                сompletion()
            }
        }
    }
}
