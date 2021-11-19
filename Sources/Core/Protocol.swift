//
//  Protocol.swift
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

import Foundation

public protocol Permissionable {
    
    var status: PermissionStatus { get }
    
    var name: String { get }
    
    var usageDescriptions: [String] { get }
    
    func request(_ сompletion: @escaping () -> Void)
}

extension Permissionable {
    
    @discardableResult
    func checkUsageDescriptions() -> Bool {
        for key in usageDescriptions {
            guard let _ = Bundle.main.object(forInfoDictionaryKey: key) else {
                fatalError("⚠️ Warning - \(key) for \(name) not found in Info.plist")
            }
        }
        return true
    }
}

public enum PermissionStatus {
    case authorized
    case denied
    case disabled
    case notDetermined
    case invalid
    
    var name: String {
        switch self {
        case .authorized:               return "Authorized"
        case .denied:                   return "Denied"
        case .disabled:                 return "Disabled"
        case .notDetermined:            return "Not Determined"
        case .invalid:                  return "Invalid"
        }
    }
}
