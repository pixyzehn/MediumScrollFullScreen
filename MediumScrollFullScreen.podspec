Pod::Spec.new do |s|
  s.name = "MediumScrollFullScreen"
  s.version = "1.0.1"
  s.summary = "Medium's upper and lower Menu in Scroll."
  s.homepage = 'https://github.com/pixyzehn/MediumScrollFullScreen'
  s.license = { :type => 'MIT', :file => 'LICENSE' }
  s.author = { "pixyzehn" => "civokjots0109@gmail.com" }

  s.requires_arc = true
  s.ios.deployment_target = "8.0"
  s.source = { :git => "https://github.com/pixyzehn/MediumScrollFullScreen.git", :tag => "#{s.version}" }
  s.source_files = "MediumScrollFullScreen/*.swift"
end
