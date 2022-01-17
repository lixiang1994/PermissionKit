//
//  Permission.Speech.swift
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

import Speech

extension Provider {
    
    public static let speech: Provider = .init(SpeechManager())
}

struct SpeechManager: Permissionable {
    
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
        return .invalid
    }
    
    var name: String { return "Speech" }
    
    var usageDescriptions: [String] {
        return ["NSMicrophoneUsageDescription",
                "NSSpeechRecognitionUsageDescription"]
    }
    
    @available(iOS 10.0, *)
    private var _status: SFSpeechRecognizerAuthorizationStatus {
        return SFSpeechRecognizer.authorizationStatus()
    }
    
    func request(_ сompletion: @escaping () -> Void) {
        guard status == .notDetermined else {
            сompletion()
            return
        }
        
        if #available(iOS 10.0, *) {
            SFSpeechRecognizer.requestAuthorization { status in
                DispatchQueue.main.async {
                    сompletion()
                }
            }
            
        } else {
            сompletion()
        }
    }
}
