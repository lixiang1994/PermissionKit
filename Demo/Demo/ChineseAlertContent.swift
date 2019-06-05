//
//  ChineseAlertContent.swift
//  Demo
//
//  Created by 李响 on 2019/6/4.
//  Copyright © 2019 swift. All rights reserved.
//

import Permission

public struct ChineseAlertContent: PermissionAlertContentSource {
    
    public init() { }
    
    public func title(_ status: AlertStatus) -> String {
        switch status {
        case .prepare(let name):
            return "\(Bundle.main.appName) 想要访问你的 \(name)"
            
        case .denied(let name):
            return "\(name) 的权限被拒绝"
            
        case .disabled(let name):
            return "\(name) 已被停用"
        }
    }
    
    public func message(_ status: AlertStatus) -> String {
        switch status {
        case .prepare(let name):
            return "请开启 \(name) 的访问权限"
            
        case .denied(let name):
            return "请开启设置APP中的 \(name) 权限"
            
        case .disabled(let name):
            return "请开启设置APP中的 \(name) 权限"
        }
    }
    
    public func cancelAction(_ status: AlertStatus) -> String {
        switch status {
        case .prepare:
            return "取消"
            
        case .denied:
            return "取消"
            
        case .disabled:
            return "好的"
        }
    }
    
    public func confirmAction(_ status: AlertStatus) -> String {
        switch status {
        case .prepare:
            return "确定"
            
        case .denied:
            return "设置"
            
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

