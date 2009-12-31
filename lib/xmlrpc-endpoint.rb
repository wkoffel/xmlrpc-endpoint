module ActionController
  module Acts
    module XmlrpcEndpoint

      def self.included(controller)
        controller.extend(ClassMethods)
      end

      module ClassMethods
        def exposes_xmlrpc_methods
          before_filter(:add_method_handlers)
        end
      end

      module InstanceMethods
        def index
          result = @xmlrpc_server.process(request.body)
          puts "\n\n----- BEGIN RESULT -----\n#{result}----- END RESULT -----\n\n"
          render :text => result, :content_type => 'text/xml'
        end

        private
      
        def add_method_handlers
          @xmlrpc_server = XMLRPC::BasicServer.new
          # loop through all the methods, adding them as handlers
          self.class.instance_methods(false).each do |method|
            unless ['index'].member?(method)
              puts "Adding XMLRPC method for #{method.to_s}"
              @xmlrpc_server.add_handler(method) do |*args|
                self.send(method.to_sym, *args)
              end
            end
          end
        end
      end
    end
  end
end
