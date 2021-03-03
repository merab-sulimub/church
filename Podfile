# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'churchApp' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for churchApp
  pod 'AppCenter' # App Center  
  
  # Google Maps
  pod 'GoogleMaps'
  pod 'GooglePlaces'
  
  # Agora - streams, video 
  pod 'AgoraRtcEngine_iOS'
  pod 'AgoraRtm_iOS'
  
  # YouTube Stream/URL extractor
  pod "XCDYouTubeKit", "~> 2.15"
  
  # Internal DB
  pod 'RealmSwift'
  
  
  # Image & Cache loader for UIKit & SwiftUI?
  pod 'Nuke', '~> 9.0'
  
end


post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
        config.build_settings.delete('CODE_SIGNING_ALLOWED')
        config.build_settings.delete('CODE_SIGNING_REQUIRED')
    end
end
