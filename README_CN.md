
# Permission
Permission Manager

![Swift](https://img.shields.io/badge/Swift-5.0-orange.svg)


## 特性

- [x] 相机.
- [x] 相册.
- [x] 联系人.
- [x] 日历.
- [x] 提醒.
- [x] 媒体库.
- [x] 麦克风.
- [x] Siri.
- [x] 动作.
- [x] 语音.
- [x] 定位.
- [x] 通知.

## 安装

**CocoaPods - Podfile**

```ruby
source 'https://github.com/lixiang1994/Specs'

pod 'Permission'
```

**Carthage - Cartfile**

```ruby
github "lixiang1994/Permission"
```

## 使用

首先导入:

```swift
import Permission
```

下面是一些简单示例. 支持所有设备和模拟器:

### 属性
```swift
Permission.camera.isAuthorized

Permission.photos.isAuthorized

Permission.XXXXXX.isAuthorized
```

### 方法
```swift
Permission.camera.request { (result) in
print("isAuthorized: \(result)")
}

Permission.XXXXXX.request { (result) in
print("isAuthorized: \(result)")
}
```

### Alert
```

```

## 贡献

如果你需要实现特定功能或遇到错误，请打开issue。 如果你自己扩展了Permission的功能并希望其他人也使用它，请提交拉取请求。


## 协议

Permission 使用 MIT 协议. 有关更多信息，请参阅 [LICENSE](LICENSE) 文件.
