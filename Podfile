platform :ios, '8.0'
use_frameworks!

target 'Uther' do
    pod 'KeyboardMan'
    pod 'JSQMessagesViewController'
    pod 'AsyncSwift'
    pod 'Alamofire'
    pod 'SwiftyJSON'
    pod 'XCGLogger'
    pod 'SQLite.swift'
    pod 'SwiftDate'
    pod 'CryptoSwift'
    pod 'SwiftHEXColors'
    pod 'LTMorphingLabel'
    pod 'Moya'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end
