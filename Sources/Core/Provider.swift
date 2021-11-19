//
//  Provider.swift
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

import UIKit

public class Provider {
    
    let manager: () -> Permissionable
    
    /// 是否授权
    public var isAuthorized: Bool {
        return manager().status == .authorized
    }
    
    /// 授权状态
    public var status: PermissionStatus {
        return manager().status
    }
    
    public init(_ manager: @escaping @autoclosure () -> Permissionable) {
        self.manager = manager
    }
    
    /// 别名
    public var alias: (() -> String)?
    
    /// 请求授权
    ///
    /// - Parameters:
    ///   - сompletion: 结果回调
    public func request(_ сompletion: @escaping (Bool) -> Void) {
        let manager = self.manager()
        manager.checkUsageDescriptions()
        manager.request {
            сompletion(manager.status == .authorized)
        }
    }
}
