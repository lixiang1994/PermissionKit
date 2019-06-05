//
//  DefaultAlertContent.swift
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

public struct DefaultAlertContent: PermissionAlertContentSource {
    
    public init() { }
    
    public func title(_ status: AlertStatus) -> String {
        switch status {
        case .prepare(let name):
            return "\(Bundle.main.appName) would like to access your \(name)"
            
        case .denied(let name):
            return "Permission for \(name) was denied"
            
        case .disabled(let name):
            return "\(name) is currently disabled"
        }
    }
    
    public func message(_ status: AlertStatus) -> String {
        switch status {
        case .prepare(let name):
            return "Please enable access to \(name)."
            
        case .denied(let name):
            return "Please enable access to \(name) in the Settings app."
            
        case .disabled(let name):
            return "Please enable access to \(name) in the Settings app."
        }
    }
    
    public func cancelAction(_ status: AlertStatus) -> String {
        switch status {
        case .prepare:
            return "Cancel"
            
        case .denied:
            return "Cancel"
            
        case .disabled:
            return "OK"
        }
    }
    
    public func confirmAction(_ status: AlertStatus) -> String {
        switch status {
        case .prepare:
            return "Confirm"
            
        case .denied:
            return "Settings"
            
        case .disabled:
            return ""
        }
    }
}

fileprivate extension Bundle {
    
    var appName: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? ""
    }
}
