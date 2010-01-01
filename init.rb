$:.unshift "#{File.dirname(__FILE__)}/lib"
ActionController::Base.send(:include, ActionController::Acts::XmlrpcEndpoint )
