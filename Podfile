# Uncomment this line to define a global platform for your project
# platform :ios, '9.0'

target 'OpenPantry' do
  # Comment this line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for OpenPantry
  pod 'SwiftyJSON'
  pod 'Alamofire', :git => 'https://github.com/Alamofire/Alamofire.git', :tag => '3.5.0'
  pod 'Firebase'
  pod 'Firebase/Auth'
  pod 'Firebase/Storage'
  pod 'Firebase/Database'
  pod 'FBSDKLoginKit'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '2.3'
        end
    end
end