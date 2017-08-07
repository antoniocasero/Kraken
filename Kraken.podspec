Pod::Spec.new do |s|
  s.name         = "Kraken"
  s.version      = "1.0.0"
  s.summary      = "Lightweight wrapper for Kraken Digital Asset Trading Platform"


  s.homepage     = "https://github.com/ArtSabintsev/Zephyr"
  s.license      = "MIT"
  s.authors      = { "Antonio Casero" => "anto.casero@gmail.com"}

  s.platform = :ios, :osx, :tvos
  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.9'
  s.tvos.deployment_target = '9.0'

  s.source       = { :git => "https://github.com/antoniocasero/Kraken.git", :tag => s.version.to_s }
  s.source_files = 'Kraken.swift'
  s.requires_arc = true
  
end
