#
# Be sure to run `pod lib lint MoreOperationView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MoreOperationView'
  s.version          = '0.1.0'
  s.summary          = 'A More Operation View.'

  s.homepage         = 'https://github.com/Musjoy/MoreOperationView'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Raymond' => 'Ray.musjoy@gmail.com' }
  s.source           = { :git => 'https://github.com/Musjoy/MoreOperationView.git', :tag => "v-#{s.version}" }

  s.ios.deployment_target = '7.0'

  s.source_files = 'MoreOperationView/Classes/**/*'

  s.user_target_xcconfig = {
    'GCC_PREPROCESSOR_DEFINITIONS' => 'MODULE_MORE_OPERATION_VIEW'
  }

  s.dependency 'ModuleCapability', '~> 0.1.2'
  s.prefix_header_contents = '#import "ModuleCapability.h"'

end
