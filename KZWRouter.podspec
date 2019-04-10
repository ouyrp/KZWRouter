#
# Be sure to run `pod lib lint KZWRouter.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'KZWRouter'
  s.version          = '3.0.4'
  s.summary          = 'A short description of KZWRouter.'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/ouyrp/KZWRouter'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ouyrp' => 'rp.ouyang001@bkjk.com' }
  s.source           = { :git => 'https://github.com/ouyrp/KZWRouter.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'
  s.source_files = 'KZWRouter/Classes/**/*'
  s.frameworks = 'UIKit'
  
end
