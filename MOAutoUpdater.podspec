Pod::Spec.new do |s|
  s.name         = "MOAutoUpdater"
  s.version      = "1.0.1"
  s.summary      = "MacOSX Application Updater"
  s.description  = <<-DESC
                     MOAutoUpdater updates and relaunches your application.
                    DESC
  s.homepage     = "http://github.com/mash/MOAutoUpdater/"
  s.license      = 'MIT'
  s.author       = { "Masakazu OHTSUKA" => "o.masakazu@gmail.com" }
  s.source       = { :git => "https://github.com/mash/MOAutoUpdater.git", :tag => "1.0.1" }
  s.platform     = :osx, '10.9'
  s.source_files = 'MOAutoUpdater/*.{h,m}'
  s.public_header_files = 'MOAutoUpdater/'

  s.resources = 'Products/Updater.app'
  s.requires_arc = true
  s.dependency 'AFNetworking', '~> 2.1.0'
  s.dependency 'EDSemver', '= 0.3.0'
end
