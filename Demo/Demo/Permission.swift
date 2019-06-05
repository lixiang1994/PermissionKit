//
//  Permission.swift
//  Demo
//
//  Created by 李响 on 2019/6/5.
//  Copyright © 2019 swift. All rights reserved.
//

import Permission

enum Permission {
    
    enum Mode {
        case camera
        case photos
        case calendar
        case reminder
        case contacts
        case speech
        case motion
        case media
        case siri
        case microphone
        case location(Provider.LocationType)
        case notification
        
        var provider: Provider {
            let mode: Provider
            switch self {
            case .camera:
                mode = Provider.camera
                mode.alias = { "相机" }
                
            case .photos:
                mode = Provider.photos
                mode.alias = { "相册" }
                
            case .calendar:
                mode = Provider.calendar
                mode.alias = { "カレンダー" }
                
            case .reminder:
                mode = Provider.reminder
                mode.alias = { "提醒" }
                
            case .contacts:
                mode = Provider.contacts
                mode.alias = { "주소록" }
                
            case .speech:
                mode = Provider.speech
                mode.alias = { "语音" }
                
            case .motion:
                mode = Provider.motion
                mode.alias = { "动作" }
                
            case .media:
                mode = Provider.media
                mode.alias = { "媒体库" }
                
            case .siri:
                mode = Provider.siri
                mode.alias = { "Siri" }
                
            case .microphone:
                mode = Provider.microphone
                mode.alias = { "麦克风" }
                
            case .location(let value):
                mode = Provider.location(value)
                mode.alias = { "定位" }
                
            case .notification:
                mode = Provider.notification
                mode.alias = { "通知" }
            }
            return mode
        }
    }
    
    public static func isAuthorized(_ mode: Mode) -> Bool {
        return mode.provider.isAuthorized
    }
    
    public static func request(_ mode: Mode, with сompletion: @escaping (Bool) -> Void) {
        let alert = SystemAlert(ChineseAlertContent())
        mode.provider.request(alert, with: сompletion)
    }
}
