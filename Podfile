source 'ssh://git@git.railwaymen.org:10522/open/rwm_podspec.git'
source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '13.3'
use_frameworks!

def universal_pods
  pod 'CoordinatorsFoundation', '~> 0.2.2'
  pod 'Firebase/Analytics'
  pod 'Firebase/Core', '~> 6.23.0'
  pod 'Firebase/Crashlytics'
  pod 'KeychainAccess', '~> 4.1'
  pod 'R.swift', '~> 5.2.0'
  pod 'Restler', '~> 0.5.2'
  pod 'SwiftLint', '~> 0.39'
end

target 'TimeTable' do
  universal_pods
end

target 'TimeTableTests' do
  pod 'JSONFactorable', '~> 0.2.2'
  universal_pods
end

target 'TimeTableUITests' do
  pod 'Swifter', '~> 1.4.7'
  universal_pods
end
