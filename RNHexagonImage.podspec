require 'json'

Pod::Spec.new do |s|
  package = JSON.parse(File.read(File.join(__dir__, 'package.json')))

  s.name          = "RNHexagonImage"
  s.version       = package['version']
  s.summary       = package['description']
  s.authors       = { "Jafar Jabr <jafar.jabr.dev@gmail.com> (https://github.com/jafar-jabr)" }
  s.homepage      = "https://github.com/jafar-jabr/react-native-hexagon-image#readme"
  s.license       = "MIT"
  s.platforms     = { :ios => "8.0", :tvos => "9.0" }
  s.framework     = 'UIKit'
  s.requires_arc  = true
  s.source        = { :git => "https://github.com/jafar-jabr/react-native-hexagon.git", :tag => "v#{s.version}" }
  s.source_files  = "ios/**/*.{h,m}"

  s.dependency 'React-Core'
  s.dependency 'SDWebImage', '~> 5.11.1'
  s.dependency 'SDWebImageWebPCoder', '~> 0.8.4'
end
