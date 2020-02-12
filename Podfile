source 'ssh://git@git.railwaymen.org:10522/open/rwm_podspec.git'
source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '11.4'
use_frameworks!

def universal_pods
  pod 'CoordinatorsFoundation', '~> 0.2.1'
  pod 'CoreStore', '~> 7.0'
  pod 'Firebase/Analytics'
  pod 'Firebase/Core', '~> 6.17.0'
  pod 'Firebase/Crashlytics'
  pod 'KeychainAccess', '~> 4.1'
  pod 'Networking', '~> 5.0.1'
  pod 'SwiftLint', '~> 0.37'
end


target 'TimeTable' do
  universal_pods
end

target 'TimeTableTests' do
  pod 'JSONFactorable', '~> 0.2.0'
  universal_pods
end
