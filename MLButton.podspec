#
#  Be sure to run `pod spec lint MLButton.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  spec.name         = "MLButton"
  spec.version      = "1.0.4"
  spec.summary      = "UIButton 自定义控件，可以设置图片的位置、角标以及角标的位置。 / A custom UIButton, can set imageView's position, badge and badge's position."

  spec.description  = <<-DESC
                  - A custom UIButton, can set imageView's position, badge and badge's position.
                  - UIButton 自定义控件，可以设置图片的位置、角标以及角标的位置。
                  - iOS 8+
                  - Xcode 11.3+
                   DESC

  spec.homepage     = "https://github.com/meilbn/MLButton"
  spec.screenshots  = "https://github.com/meilbn/MLButton/blob/master/Screenshots/Simulator-Screen-Shot-iPhone-11-Pro-Max.png"

  spec.license      = "MIT"

  spec.author             = { "Meilbn" => "codingallnight@gmail.com" }
  
  spec.platform     = :ios, "8.0"
  spec.swift_versions = ['5.0']

  spec.source       = { :git => "https://github.com/meilbn/MLButton.git", :tag => "#{spec.version}" }

  spec.source_files  = "MLButton/*.swift"

end
