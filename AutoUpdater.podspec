Pod::Spec.new do |s|
  s.name         = "AutoUpdater"
  s.version      = "1.0.0"
  s.summary      = "MacOSX Application Updater"
  s.description  = <<-DESC
                     AutoUpdater updates and relaunches your application.
                    DESC
  s.homepage     = "http://github.com/mash/CocoaAutoUpdater/"
  s.license      = 'MIT'
  s.author       = { "Masakazu OHTSUKA" => "o.masakazu@gmail.com" }
  s.source       = { :git => "https://github.com/mash/CocoaAutoUpdater.git", :tag => "1.0.0" }
  s.platform     = :osx, '10.9'
  s.source_files = 'AutoUpdater/*.{h,m}'
  s.public_header_files = 'AutoUpdater/'

  s.resources = 'Products/AutoUpdater.app'
  s.requires_arc = true
end
