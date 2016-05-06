#
#  Be sure to run `pod spec lint BFGCallbackRouter.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name         = "BFGCallbackRouter"
  s.version      = "1.1.0"
  s.summary      = "Simple URL router supporting the x-callback-url 1.0 DRAFT spec."
  s.description  = <<-DESC
                   ``BFGCallbackRouter`` is an implementation of the [x-callback-url 1.0 DRAFT Spec](http://x-callback-url.com/specifications/) in Objective-C for use in iOS applications. The intention was to create a simple, light, and flexible implementation.
                   DESC

  s.homepage     = "https://github.com/blackfog/BFGCallbackRouter"
  s.license      = "MIT"
  s.author             = { "Craig Pearlman" => "github-public@craig.blackfog.net" }
  s.social_media_url   = "http://twitter.com/blackfog"
  s.platform     = :ios, "8.1"
  s.source       = { :git => "https://github.com/blackfog/BFGCallbackRouter.git", :tag => "1.1.0" }
  s.source_files  = "Source/*.{h,m}"
  s.requires_arc = true
end
