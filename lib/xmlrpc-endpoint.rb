# This file loads when the gem is included, and does plugin-style initialization

module ActionController::Acts
	autoload :XmlrpcEndpoint, "#{File.dirname(__FILE__)}/action_controller/acts/xmlrpc_endpoint.rb"
end

ActionController::Base.send(:include, ActionController::Acts::XmlrpcEndpoint )

