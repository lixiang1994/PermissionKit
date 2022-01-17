# PermissionKit
Permission Manager

![Swift](https://img.shields.io/badge/Swift-5.0-orange.svg)

## [天朝子民🇨🇳](README_CN.md)

## Features

- [x] Camera.
- [x] Photos.
- [x] Contacts.
- [x] Calendar.
- [x] Reminder.
- [x] Media Library.
- [x] Microphone.
- [x] Siri.
- [x] Motion.
- [x] Speech.
- [x] Location.
- [x] Notification.
- [x] AppTracking.
- [x] Bluetooth.

## Installation

**CocoaPods - Podfile**

```ruby
source 'https://github.com/lixiang1994/Specs'

// All
pod 'PermissionKit'

// Add separately
pod 'PermissionKit/Camera'
pod 'PermissionKit/Photos'
pod 'PermissionKit/Contacts'
pod 'PermissionKit/Event'
pod 'PermissionKit/Motion'
pod 'PermissionKit/Speech'
pod 'PermissionKit/Media'
pod 'PermissionKit/Siri'
pod 'PermissionKit/Location'
pod 'PermissionKit/Notification'
pod 'PermissionKit/Tracking'
pod 'PermissionKit/Bluetooth'
```

**Carthage - Cartfile**

```ruby
github "lixiang1994/PermissionKit"
```

## Usage

First make sure to import the framework:

```swift
import PermissionKit
```

Here are some usage examples. All devices are also available as simulators:


### Property
```swift
Provider.camera.isAuthorized

Provider.photos.isAuthorized

Provider.XXXXXX.isAuthorized
```

### Functions
```swift
Provider.camera.request { (result) in
    print("isAuthorized: \(result)")
}

Provider.XXXXXX.request { (result) in
    print("isAuthorized: \(result)")
}
```

### Alert

#### Protocol
```swift
public protocol PermissionAlertable {

    init(_ source: PermissionAlertContentSource)

    func show(_ status: AlertStatus, with сompletion: @escaping (Bool) -> Void)
}
```
#### SystemAlert based `UIAlertController`
```
let alert = SystemAlert(ChineseAlertContent())
Provider.camera.request(alert) { result in
    /* ... */
}
```
CustomAlert  need to implement `PermissionAlertable` protocol

## Contributing

If you have the need for a specific feature that you want implemented or if you experienced a bug, please open an issue.
If you extended the functionality of PermissionKit yourself and want others to use it too, please submit a pull request.


## License

PermissionKit is under MIT license. See the [LICENSE](LICENSE) file for more info.
