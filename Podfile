# Uncomment the next line to define a global platform for your project
# platform :ios, '10.0'

source 'https://github.com/CocoaPods/Specs.git'

# ignore all warnings from all pods

inhibit_all_warnings!

def shared_pods

    pod 'Masonry'
    pod 'AFNetworking'
    pod 'MJRefresh'
    pod 'RealReachability'
    pod 'YYImage'
    pod 'YYImage/WebP'
    pod 'YYWebImage'
    pod 'YYModel'
    pod 'DZNEmptyDataSet'
    pod 'JLRoutes'
    pod 'MBProgressHUD'
    pod 'IQKeyboardManager'
    pod 'ReactiveCocoa', :git => 'https://github.com/zhao0/ReactiveCocoa.git', :tag => '2.5.2'
    pod 'YHDragContainer'
    pod 'JXCategoryView'
    pod 'BGFMDB'
    pod 'Qiniu'
    pod 'JPVideoPlayer'
    pod 'JPNavigationController', '~> 2.1.3'
    pod 'KTVHTTPCache', '~> 1.1.5'
    pod 'IQKeyboardManager'
    pod 'UMCCommon'
    pod 'UMCPush'
    pod 'UMCSecurityPlugins'
    pod 'UMCAnalytics'
    pod 'JMessage'
    pod 'WechatOpenSDK'
    pod 'Weibo_SDK', :git => 'https://github.com/sinaweibosdk/weibo_ios_sdk.git'

    post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            if config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'].to_f < 8.0
                config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '8.0'
                end
            end
        end
    end
end


target 'Earth' do
   shared_pods
end

target 'EarthTests' do
   inherit! :search_paths
   #Pods for testing
end

target 'EarthUITests' do
   inherit! :search_paths
   # Pods for testing
end

