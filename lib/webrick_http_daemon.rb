# webrick_http_daemon.rb
begin
  require 'win32/daemon'
  require 'win32/dir'
  require 'webrick'
  require 'yaml'
  require 'logger'

  include WEBrick
  include Win32

  # TODO: Setup an event log source
  LOG = File.join(Dir::PROGRAM_FILESX86, 'RubyServices', 'WEBrick', 'http_service.log').tr("/", "\\")

  class WebrickHttpDaemon < Daemon
    # The version of the webrick-service gem
    VERSION = '0.1.0'.freeze

    def initialize
      Dir.chdir(File.join(Dir::PROGRAM_FILESX86, 'RubyServices', 'WEBrick'))

      @config = YAML.load(File.open('webrick_config.yaml'))

      @webrick_port = @config['port']
      @webrick_root = @config['docroot']
      @webrick_log  = File.join(@config['home'], 'webrick.log')

      @service_log = Logger.new(LOG, 'weekly')

      @http = HTTPServer.new(
        :Port          => @webrick_port,
        :DocumentRoot  => @webrick_root,
        :Logger        => WEBrick::Log.new(@webrick_log)
      )
    end

    def service_main
      @service_log.info{ "WEBrick Service started at: " + Time.now.to_s }

      begin
        @http.start
      rescue Exception => err
        @service_log.error{ err }
        service_stop
      end
    end

    def service_stop
      @http.shutdown rescue nil
      @service_log.info{ "WEBrick Service stopped at: " + Time.now.to_s }
      exit!
    end
  end

  WebrickHttpDaemon.new.mainloop
rescue Exception => err
  File.open(LOG, 'a') do |fh|
    fh.puts err
    fh.puts err.backtrace.join("\n")
    fh.puts "=" * 40
  end
  raise
end
