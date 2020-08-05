#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_kbzpay.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_kbzpay'
  s.version          = '0.0.1'
  s.summary          = 'KBZ Pay For Flutter'
  s.description      = <<-DESC
KBZ Pay For Flutter
                       DESC
  s.homepage         = 'http://yesdoctor.asia'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Yes Doctor' => 'hello@yesdoctor.asia' }
  s.source           = { :path => '.' }
  s.ios.vendored_frameworks = 'Frameworks/KBZPayAPPPay.framework'
  s.vendored_frameworks = 'KBZPayAPPPay.framework'
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'

  s.ios.deployment_target = '8.0'
end
