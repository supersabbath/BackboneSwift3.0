source 'https://github.com/CocoaPods/Specs.git'

use_frameworks!

def libraries
    
    pod 'Alamofire'
    pod 'PromiseKit/CorePromise'
    pod 'SwiftyJSON'
    
end

target :'BackboneSwift' do
    platform :ios, '9.0'
    libraries
    
end

target :'BackboneSwift-tvOS' do
    platform :tvos, '9.1'
    libraries
end

target :'BackboneSwiftTests' do
    libraries
end


post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end
