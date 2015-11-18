Pod::Spec.new do |spec|
  spec.name              = 'SCAvatarBrowser'
  spec.version           = '1.1.0'
  spec.license           = { :type => 'MIT', :file => 'LICENSE' }
  spec.homepage          = 'https://github.com/luosch/SCAvatarBrowser'
  spec.authors           = { 'Sicheng Luo' => 'me@lsich.com' }
  spec.summary           = 'provide detail view of thumb image for iOS'
  spec.source            = { :git => 'https://github.com/luosch/SCAvatarBrowser.git', :tag => 'v1.1.0'}
  spec.source_files      = 'Classes/*.{h,m}'
  spec.framework         = 'Foundation', 'UIKit'
  spec.requires_arc      = true
  spec.platform          = :ios, '7.0'
end