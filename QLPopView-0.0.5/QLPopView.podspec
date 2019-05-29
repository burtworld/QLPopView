Pod::Spec.new do |s|
  s.name = "QLPopView"
  s.version = "0.0.5"
  s.summary = "a popview with custom container,you can use it pop a table,a lable,a buttom or others"
  s.license = "MIT"
  s.authors = {"paramita"=>"baqkoo007@aliyun.com"}
  s.homepage = "https://github.com/burtworld/QLPopView"
  s.requires_arc = true
  s.source = { :path => '.' }

  s.ios.deployment_target    = '8.0'
  s.ios.vendored_framework   = 'ios/QLPopView.embeddedframework/QLPopView.framework'
end
