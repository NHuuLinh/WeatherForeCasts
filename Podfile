# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

platform :ios, '15.0'

target 'WeatherForeCasts' do
  use_frameworks!

  pod 'FirebaseAuth'
  pod 'FirebaseDatabase'
  pod 'FirebaseFirestore'
  pod 'Firebase/Storage'
  pod 'Alamofire', '5.8.0'
  pod 'SwiftyJSON', '~> 4.0'
  pod 'Kingfisher'
  pod 'Charts'
  pod 'KeychainSwift'
  pod 'MBProgressHUD', '~> 1.2.0'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '16.6'
    end

    if target.name == 'BoringSSL-GRPC'
      target.source_build_phase.files.each do |file|
        if file.settings && file.settings['COMPILER_FLAGS']
          flags = file.settings['COMPILER_FLAGS'].split
          flags.reject! { |flag| flag == '-G' || flag.start_with?('-G') }
          file.settings['COMPILER_FLAGS'] = flags.join(' ')
        end
      end
    end
  end
end
