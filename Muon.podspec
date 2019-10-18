Pod::Spec.new do |s|
  s.name         = "Muon"
  s.version      = "1.2.0"
  s.summary      = "An RSS/Atom Parser in Swift."

  s.homepage     = "https://github.com/younata/Muon"
  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author       = "Rachel Brindle"
  s.ios.deployment_target = "13.0"
  s.osx.deployment_target = "10.14"
  s.tvos.deployment_target = "13.0"
  s.watchos.deployment_target = "6.0"

  s.source       = { :git => "https://github.com/younata/Muon.git" }
  s.source_files  = "Muon", "Sources/**/*.{swift,h,m}"

  s.requires_arc = true
end
