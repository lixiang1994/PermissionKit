Pod::Spec.new do |s|

s.name         = 'PermissionKit'
s.version      = '1.0.3'
s.summary      = 'An elegant permission manager written in swift'

s.homepage     = 'https://github.com/lixiang1994/PermissionKit'

s.license      = { :type => 'MIT', :file => 'LICENSE' }

s.author       = { 'LEE' => '18611401994@163.com' }

s.platform     = :ios, '9.0'

s.source       = { :git => 'https://github.com/lixiang1994/PermissionKit.git', :tag => s.version }

s.source_files  = 'Sources/**/*.swift'

s.requires_arc = true

s.frameworks = 'UIKit', 'Foundation'

s.swift_version = '5.0'

s.default_subspec = 'Core'

s.subspec 'Core' do |sub|
    sub.source_files  = 'Sources/Core/*.swift'
end

s.subspec 'Alert' do |sub|
    sub.dependency 'Permission/Core'
    sub.source_files  = 'Sources/Alert/*.swift'
end

s.subspec 'Camera' do |sub|
    sub.dependency 'Permission/Core'
    sub.source_files  = 'Sources/Managers/Permission+Camera.swift'
    sub.weak_framework = 'AVFoundation'
end

s.subspec 'Photos' do |sub|
    sub.dependency 'Permission/Core'
    sub.source_files  = 'Sources/Managers/Permission+Photos.swift'
    sub.weak_framework = 'Photos'
end

s.subspec 'Event' do |sub|
    sub.dependency 'Permission/Core'
    sub.source_files  = 'Sources/Managers/Permission+Event.swift'
    sub.weak_framework = 'EventKit'
end

s.subspec 'Contacts' do |sub|
    sub.dependency 'Permission/Core'
    sub.source_files  = 'Sources/Managers/Permission+Contacts.swift'
    sub.weak_framework = 'Contacts'
end

s.subspec 'Speech' do |sub|
    sub.dependency 'Permission/Core'
    sub.source_files  = 'Sources/Managers/Permission+Speech.swift'
    sub.weak_framework = 'Speech'
end

s.subspec 'Motion' do |sub|
    sub.dependency 'Permission/Core'
    sub.source_files  = 'Sources/Managers/Permission+Motion.swift'
    sub.weak_framework = 'CoreMotion'
end

s.subspec 'Media' do |sub|
    sub.dependency 'Permission/Core'
    sub.source_files  = 'Sources/Managers/Permission+Media.swift'
    sub.weak_framework = 'MediaPlayer'
end

s.subspec 'Siri' do |sub|
    sub.dependency 'Permission/Core'
    sub.source_files  = 'Sources/Managers/Permission+Siri.swift'
    sub.weak_frameworks = 'Intents'
end

s.subspec 'Location' do |sub|
    sub.dependency 'Permission/Core'
    sub.source_files  = 'Sources/Managers/Permission+Location.swift'
    sub.weak_framework = 'CoreLocation'
end

s.subspec 'Notification' do |sub|
    sub.dependency 'Permission/Core'
    sub.source_files  = 'Sources/Managers/Permission+Notification.swift'
    sub.weak_framework = 'UserNotifications'
end

end
