//
//  Provider+Alert.swift
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

/// 提示框状态
///
/// - prepare:  准备
/// - denied:   拒绝
/// - disabled: 停用
public enum AlertStatus {
    case prepare(String)
    case denied(String)
    case disabled(String)
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

extension Provider {
    
    /// 请求授权
    ///
    /// - Parameters:
    ///   - alert: 弹窗
    ///   - сompletion: 结果回调
    public func request(_ alert: PermissionAlertable = SystemAlert(),
                        with сompletion: @escaping (Bool) -> Void) {
        let manager = self.manager()
        let name = self.alias?() ?? manager.name
        manager.checkUsageDescriptions()
        switch manager.status {
        case .authorized:
            manager.request {
                сompletion(true)
            }
            
        case .denied:
            alert.show(.denied(name)) { result in
                guard result else {
                    сompletion(false)
                    return
                }
                DispatchQueue.main.async {
                    сompletion(manager.status == .authorized)
                }
            }
            
        case .disabled:
            alert.show(.disabled(name), with: сompletion)
            
        case .notDetermined:
            alert.show(.prepare(name)) { result in
                guard result else {
                    сompletion(false)
                    return
                }
                manager.request {
                    сompletion(manager.status == .authorized)
                }
            }
            
        case .invalid:
            сompletion(false)
        }
    }
}
