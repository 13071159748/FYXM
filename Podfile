source 'https://github.com/CocoaPods/Specs.git'
    target 'CQSC' do
platform :ios, '9.0'
inhibit_all_warnings!
use_frameworks!

pod 'MBProgressHUD', '~> 1.0.0'
pod 'PSAlertView', '~> 2.0.3'
pod 'Reachability', '~> 3.2'
pod 'Base64', '~> 1.1.2'
pod 'SDWebImage', '~> 4.3.3'
pod 'GZIP', '~> 1.1.1'
pod 'iVersion', '~> 1.11.5'
pod 'MJRefresh', '~> 3.1.12'
pod 'UITableView+FDTemplateLayoutCell', '~> 1.4'
pod 'FMDB', '~> 2.7.2'

pod 'UICKeyChainStore' # 钥匙链.
pod 'AFNetworking' # 网络监控.
pod 'NSData+MD5Digest' # MD5 验证.

pod 'SDWebImage/GIF'
pod 'FLAnimatedImage'

pod 'Masonry' ,'~>1.1.0'


#swift-5.0
 pod 'Toast-Swift' , '~> 5.0.1'
 pod 'SnapKit' , '~> 4.2.0'
 pod 'Alamofire' , '~> 4.9.1'
 pod 'KeychainSwift' , '~> 18.0.0'
 pod 'RxSwift' ,' ~>5.0.1'
 pod 'RxCocoa' ,' ~>5.0.1'
 pod 'Spring', :git => 'https://github.com/MengTo/Spring.git' , :branch => 'swift5'
 pod 'TwitterKit', '~> 3.4.2'
 pod 'Fabric', '~> 1.7.13'
 pod 'Crashlytics', '~> 3.10.9'
 
 pod 'FBSDKLoginKit', '~>  5.3.0'
 pod 'FBSDKShareKit', '~>  5.3.0'
 pod 'FBSDKCoreKit', '~>  5.3.0'

 
 pod 'Firebase/Core', '~> 6.13.0'
 pod 'Firebase/Messaging'
 pod 'Firebase/Performance'
 pod 'Firebase/Analytics'
 pod 'Firebase/DynamicLinks'
 pod 'Firebase/RemoteConfig'
 pod 'FacebookCore'
 pod 'FSPagerView'
 
 pod 'GoogleSignIn' ,'~>5.0.0'
  
 pod 'DoraemonKit/Core', '~> 2.0.0', :configurations => ['Debug']
 pod 'DoraemonKit/WithLogger', '~> 2.0.0', :configurations => ['Debug']
 pod 'DoraemonKit/WithGPS', '~> 2.0.0', :configurations => ['Debug']
 pod 'DoraemonKit/WithLoad', '~> 2.0.0', :configurations => ['Debug']
  
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['ENABLE_BITCODE'] = 'NO'
        end
    end
end
