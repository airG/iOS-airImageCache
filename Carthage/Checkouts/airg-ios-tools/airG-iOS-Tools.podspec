Pod::Spec.new do |spec|
  spec.name = "airG-iOS-Tools"
  spec.version = "1.0.3"
  spec.summary = "Shared utilities written in Swift."
  spec.homepage = "http://gitlab.airg.us/stevent/airg-ios-tools"
  spec.license = { type: 'MIT', file: 'LICENSE' }
  spec.authors = { "Steven Thompson" => 'stevent@airg.com' }

  spec.platform = :ios, "8.0"
  spec.requires_arc = true
  spec.source = { git: "http://gitlab.airg.us/stevent/airg-ios-tools.git", tag: "v#{spec.version}", submodules: true }
  spec.source_files = "airG-iOS-Tools/**/*.{h,swift}"

end