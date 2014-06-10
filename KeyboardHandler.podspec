Pod::Spec.new do |s|
    s.name         = "KeyboardHandler"
    s.version      = "0.1.2"
    s.summary      = "Manager for keyboard appear/disappear"
    s.homepage     = "https://github.com/Igor-Palaguta/KeyboardHandler"
    s.license      = 'MIT'
    s.author       = { "Igor Palaguta" => "igor.palaguta@gmail.com" }

    s.platform     = :ios, '5.0'
    s.requires_arc = true

    s.header_mappings_dir = 'KeyboardHandler'

    s.source_files = 'KeyboardHandler/*.{h,m}'
end
