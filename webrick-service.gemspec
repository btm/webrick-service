require 'rubygems'

Gem::Specification.new do |spec|
  spec.name       = 'webrick-service'
  spec.version    = '0.1.0'
  spec.author     = 'Daniel J. Berger'
  spec.license    = 'Apache 2.0'
  spec.email      = 'djberg96@gmail.com'
  spec.homepage   = 'http://www.github.com/djberg96/webrick-service'
  spec.summary    = 'WEBrick as a Windows service.'
  spec.files      = Dir['**/*'].reject{ |f| f.include?('git') }
  spec.cert_chain = spec.cert_chain = ['certs/djberg96_pub.pem']

  spec.executables = "webrickctl"
  spec.extra_rdoc_files = %w[CHANGES README MANIFEST]

  spec.add_dependency('win32-service')
  spec.add_dependency('getopt')

  spec.description = <<-EOF
    This gem sets up WEBrick to be installed as a Windows service. Once
    installed, use the webrickctl command to install, start and stop
    the service. Basic options are controlled via a YAML config file.
  EOF
end
