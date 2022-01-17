//
//  Permission.Bluetooth.swift
//  ┌─┐      ┌───────┐ ┌───────┐
//  │ │      │ ┌─────┘ │ ┌─────┘
//  │ │      │ └─────┐ │ └─────┐
//  │ │      │ ┌─────┘ │ ┌─────┘
//  │ └─────┐│ └─────┐ │ └─────┐
//  └───────┘└───────┘ └───────┘
//
//  Created by lee on 2021/11/22.
//  Copyright © 2021 lee. All rights reserved.
//

import Foundation
import CoreBluetooth

extension Provider {

    public static let bluetooth: Provider = .init(BluetoothManager())
}

struct BluetoothManager: Permissionable {
    
    var status: PermissionStatus {
        switch BluetoothState.status {
        case .authorized:                   return .authorized
        case .denied:                       return .denied
        case .disabled:                     return .disabled
        case .notDetermined:                return .notDetermined
        case .invalid:                      return .invalid
        }
    }
    
    var name: String { return "Bluetooth" }
    
    var usageDescriptions: [String] {
        if #available(iOS 13.0, *) {
            return ["NSBluetoothAlwaysUsageDescription"]
        }
        return ["NSBluetoothPeripheralUsageDescription"]
    }

    func request(_ сompletion: @escaping () -> Void) {
        BluetoothState.request(completion: сompletion)
    }
}

/// 获取蓝牙状态类
public enum BluetoothState {
    
    /// App 授权状态
    public enum Authorization {
        case authorized
        case denied
        case disabled
        case notDetermined
        case invalid
    }
    
    /// 系统开关状态
    public enum Powered {
        case notDetermined
        case denied
        
        case on, off
        case unknown
    }
    
    public static var status: Authorization {
        if #available(iOS 13.1, tvOS 13.1, *) {
            switch CBCentralManager.authorization {
            case .allowedAlways: return .authorized
            case .notDetermined: return .notDetermined
            case .restricted: return .denied
            case .denied: return .denied
            @unknown default: return .denied
            }
        } else if #available(iOS 13.0, tvOS 13.0, *) {
            switch CBCentralManager().authorization {
            case .allowedAlways: return .authorized
            case .notDetermined: return .notDetermined
            case .restricted: return .denied
            case .denied: return .denied
            @unknown default: return .denied
            }
        } else {
            switch CBPeripheralManager.authorizationStatus() {
            case .authorized: return .authorized
            case .denied: return .denied
            case .restricted: return .denied
            case .notDetermined: return .notDetermined
            @unknown default: return .denied
            }
        }
    }
    
    public static func request(completion: @escaping () -> Void) {
        BluetoothHandler.shared.completion = completion
        BluetoothHandler.shared.requestUpdate()
    }
    
    public static func powered(showPower: Bool = false, _ completion: @escaping (Powered) -> Void) {
        switch BluetoothState.status {
        case .authorized:
            let manager = CBCentralManager(delegate: nil, queue: nil, options: [CBCentralManagerOptionShowPowerAlertKey : showPower])
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                switch manager.state {
                case .poweredOff:   return completion(.off)
                case .poweredOn:    return completion(.on)
                case .unsupported:  return completion(.off)
                case .unauthorized: return completion(.denied)
                default:            return completion(.unknown)
                }
            }
            
        case .notDetermined:     completion(.notDetermined)
        case .denied:            completion(.denied)
        case .disabled:          completion(.denied)
        case .invalid:           completion(.unknown)
        }
    }
}

fileprivate class BluetoothHandler: NSObject, CBCentralManagerDelegate {
    
    var completion: ()->Void = {}
    
    // MARK: - Init
    
    static let shared: BluetoothHandler = .init()
    
    override init() {
        super.init()
    }
    
    // MARK: - Manager
    
    var manager: CBCentralManager?
    
    func requestUpdate() {
        if manager == nil {
            self.manager = CBCentralManager(delegate: self, queue: nil, options: [:])
        } else {
            completion()
        }
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if #available(iOS 13.0, tvOS 13, *) {
            switch central.authorization {
            case .notDetermined:
                break
            default:
                self.completion()
            }
        } else {
            switch CBPeripheralManager.authorizationStatus() {
            case .notDetermined:
                break
            default:
                self.completion()
            }
        }
    }
}
