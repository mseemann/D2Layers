#
# Be sure to run `pod lib lint D2Layers.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "D2Layers"
  s.version          = "0.1.0"
  s.summary          = "Data Driven Layers"

  s.description      = "Data Driven Layers inspired by D3.js"

  s.homepage         = "https://github.com/mseemann/D2Layers"
  s.license          = 'MIT'
  s.author           = { "Michael Seemann" => "pods@mseemann.de" }
  s.source           = { :git => "https://github.com/mseemann/D2Layers.git", :tag => s.version.to_s }

  s.platform     = :ios, '9.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'D2Layers' => ['Pod/Assets/*.png']
  }

  s.module_map = 'Pod/Classes/module.map'
end
