Pod::Spec.new do |s|
  s.name         = "Muon"
  s.version      = "0.1.0"
  s.summary      = "An RSS/Atom Parser in Swift."

  s.homepage     = "https://github.com/younata/Muon"
  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author       = "Rachel Brindle"
  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.10"
  s.tvos.deployment_target = "9.0"
  s.watchos.deployment_target = "2.0"

  s.source       = { :git => "https://github.com/younata/Muon.git" }
  s.source_files  = "Muon", "Muon/**/*.{swift,h,m}"

  s.requires_arc = true
end
