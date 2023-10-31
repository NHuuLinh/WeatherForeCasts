# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'WeatherForeCasts' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for WeatherForeCasts
  pod 'FirebaseAuth'
  pod 'Alamofire', '5.8.0'
  pod 'AlamofireImage', '4.3.0'
  pod 'SwiftyJSON', '~> 4.0'
  pod 'Kingfisher', '~> 7.0'


  
  
  pod 'FirebaseDatabase'
  pod 'FirebaseFirestore'
  pod 'MBProgressHUD', '~> 1.2.0'

  

end

post_install do |installer|
  installer.generated_projects.each do |project|
    project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
      end
    end
  end
end
