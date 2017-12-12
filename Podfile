# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'ConsumeService' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for ConsumeService

pod 'EasyRest'
pod 'MBProgressHUD'
pod 'RealmSwift'

end

post_install do |installer|
      installer.pods_project.targets.each do |target|
      compatibility_pods = ['Genome', 'SweetAlert']
          if compatibility_pods.include? target.name
              target.build_configurations.each do |config|
                  config.build_settings['SWIFT_VERSION'] = '3.2'
              end
          end
      end
  end
