require 'rake'
require 'rbconfig'
require 'win32/dir'
require 'win32/file'
require 'yaml'
include RbConfig

namespace :webrick do
  desc 'Install the WEBrick service'
  task :install, :web_dir, :bin_dir do |t, args|
    web_dir  = args[:web_dir] || File.join(Dir::PROGRAM_FILESX86, 'RubyServices', 'WEBrick') 
    bin_dir  = args[:bin_dir] || CONFIG['bindir']
    bin_file = File.join(bin_dir, 'webrickctl.cmd')

    # Create the webrickctl.cmd file
    File.open(bin_file, 'w') do |fh|
      file = File.join(bin_dir, 'webrickctl').tr("/", "\\")
      fh.puts '@ruby "' + file + '" %*'
    end
      
    FileUtils.cp('bin/webrickctl', bin_dir, :verbose => true)
         
    FileUtils.mkdir_p(web_dir)
    FileUtils.cp('webrick/webrick_config.yaml', web_dir, :verbose => true)
    FileUtils.cp('webrick/webrick_http_daemon.rb', web_dir, :verbose => true)
     
    # Automatically create the docroot if it doesn't exist already
    docroot = YAML.load(File.open('webrick/webrick_config.yaml'))['docroot']
    FileUtils.mkdir_p(docroot, :verbose => true)     
  end
end
