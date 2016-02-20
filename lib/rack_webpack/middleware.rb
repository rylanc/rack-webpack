module RackWebpack
  class Middleware
    def initialize(app)
      @app = app

    end

    def call(env)
      if env['REQUEST_PATH'] =~ /\.bundle\.js/
        Kernel.warn 'JDS Request To Proxy'

        x = SocketHttp.new( WebpackRunner.socket_path )
        request = Net::HTTP::Get.new('/assets/dashboard.bundle.js')
        resp = x.request( request )

        [resp.code, resp.to_hash, [resp.body]]
      else
        @app.call(env)
      end
    end
  end
end
