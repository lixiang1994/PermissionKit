//
//  Permission.Photos.swift
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

extension Provider {
    
    public enum PhotosType {
        case addOnly
        case readWrite
    }
    
    public static func photos(_ type: PhotosType) -> Provider {
        return .init(PhotosManager(type))
    }
}

struct PhotosManager: Permissionable {
    
    private let type: Provider.PhotosType
    
    init(_ type: Provider.PhotosType) {
        self.type = type
    }
    
    var status: PermissionStatus {
        switch _status {
        case .authorized:       return .authorized
        case .limited:          return .authorized
        case .denied:           return .denied
        case .restricted:       return .disabled
        case .notDetermined:    return .notDetermined
        @unknown default:       return .invalid
        }
    }
    
    var name: String { return "Photo Library" }
    
    var usageDescriptions: [String] {
        return ["NSPhotoLibraryUsageDescription",
                "NSPhotoLibraryAddUsageDescription"]
    }
    
    private var _status: PHAuthorizationStatus {
        if #available(iOS 14, *) {
            return PHPhotoLibrary.authorizationStatus(for: type.level)
            
        } else {
            return PHPhotoLibrary.authorizationStatus()
        }
    }
    
    func request(_ сompletion: @escaping () -> Void) {
        guard status == .notDetermined else {
            сompletion()
            return
        }
        
        if #available(iOS 14, *) {
            PHPhotoLibrary.requestAuthorization(for: type.level) { status in
                DispatchQueue.main.async {
                    сompletion()
                }
            }
            
        } else {
            PHPhotoLibrary.requestAuthorization { status in
                DispatchQueue.main.async {
                    сompletion()
                }
            }
        }
    }
}

private extension Provider.PhotosType {
    
    @available(iOS 14, *)
    var level: PHAccessLevel {
        switch self {
        case .addOnly:
            return .addOnly
            
        case .readWrite:
            return .readWrite
        }
    }
}
