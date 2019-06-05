//
//  Permission.swift
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

public enum Permission {
    
}

extension Permission {
    
    enum Status {
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
}
