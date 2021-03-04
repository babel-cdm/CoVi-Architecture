Pod::Spec.new do |spec|

# 1
spec.platform = :ios
spec.ios.deployment_target = '11.0'
spec.name = "CoVi"
spec.summary = "CoVi lets users build awesome apps with professional architecture in minutes."
spec.requires_arc = true

# 2
spec.version = "1.1.1"

# 3
spec.license = { :type => "MIT", :file => "LICENSE" }

# 4 - Replace with your name and e-mail address
spec.author = { "BABEL SI" => "cdm@babel.es" }

# 5 - Replace this URL with your own GitHub page's URL (from the address bar)
spec.homepage = "https://github.com/babel-cdm/CoVi-Architecture"

# 6 - Replace this URL with your own Git URL from "Quick Setup"
spec.source = { :git => "https://github.com/babel-cdm/CoVi-Architecture.git",
             :tag => "#{spec.version}" }

# 7
#spec.framework = "UIKit"

# 8
spec.source_files = "CoVi/**/*.{swift}"

# 9
#spec.resources = "CoVi/**/*.{png,jpeg,jpg,storyboard,xib,xcassets}"

# 10
spec.swift_version = "5.1"

end
