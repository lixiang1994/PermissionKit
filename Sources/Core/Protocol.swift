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

protocol Permissionable {
    
    var status: Permission.Status { get }
    
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

public protocol PermissionAlertable {
    
    init(_ source: PermissionAlertContentSource)
    
    func show(_ status: AlertStatus, with сompletion: @escaping (Bool) -> Void)
}

public protocol PermissionAlertContentSource {
    
    func title(_ status: AlertStatus) -> String
    
    func message(_ status: AlertStatus) -> String
    
    func cancelAction(_ status: AlertStatus) -> String
    
    func confirmAction(_ status: AlertStatus) -> String
}
