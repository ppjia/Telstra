platform :ios, '11.0'
use_frameworks!

source 'https://github.com/CocoaPods/Specs.git'

def functional_pods
    pod 'AlamofireImage'
end

target 'Telstra' do
    functional_pods
    
    target 'TelstraTests' do
        inherit! :search_paths
    end
end
