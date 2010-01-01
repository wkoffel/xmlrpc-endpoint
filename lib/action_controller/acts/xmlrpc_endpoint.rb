module ActionController
  module Acts
    module XmlrpcEndpoint
      def self.included(controller)
        controller.extend(ClassMethods)
      end

      module ClassMethods
        def exposes_xmlrpc_methods(options = {})
          configuration = { :method_prefix => nil }
          configuration.update(options) if options.is_a?(Hash)
          
          before_filter(:add_method_handlers, :only => [:index])
          class_eval <<-EOV
            require 'xmlrpc/server'
            include ActionController::Acts::XmlrpcEndpoint::InstanceMethods

            def xe_method_prefix
              '#{configuration[:method_prefix]}'
            end
          EOV
        end
      end

      module InstanceMethods
        # TODO: add route automatically for this?
        def xe_index
          result = @xmlrpc_server.process(request.body)
          puts "\n\n----- BEGIN RESULT -----\n#{result}----- END RESULT -----\n\n"
          render :text => result, :content_type => 'text/xml'
        end

        private
      
        def add_method_handlers
          @xmlrpc_server = XMLRPC::BasicServer.new
          # loop through all the methods, adding them as handlers
          self.class.instance_methods(false).each do |method|
            unless ['xe_index', 'xe_method_prefix'].member?(method)
              puts "Adding XMLRPC method for #{method.to_s}"
              @xmlrpc_server.add_handler(xe_method_prefix + method) do |*args|
                self.send(method.to_sym, *args)
              end
            end
          end
        end
      end
    end
  end
end
