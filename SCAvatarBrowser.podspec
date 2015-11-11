Pod::Spec.new do |spec|
  spec.name             = 'SCAvatarBrowser'
  spec.version          = '1.0.0'
  spec.license          = { :type => 'MIT', :file => 'LICENSE' }
  spec.homepage         = 'https://github.com/luosch/SCAvatarBrowser'
  spec.authors          = { 'Sicheng Luo' => 'me@lsich.com' }
  spec.summary          = 'provide etail view of thumb image for iOS'
  spec.source           = { :git => 'https://github.com/luosch/SCAvatarBrowser.git', :tag => 'v1.0.0'}
  spec.source_files     = 'Classes/*.{h,m}'
  spec.framework        = 'SystemConfiguration'
  spec.requires_arc     = true
  spec.platform         = :ios, '8.0'
end