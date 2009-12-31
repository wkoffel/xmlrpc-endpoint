#$:.unshift "#{File.dirname(__FILE__)}/lib"
require 'xmlrpc/server'
#require 'xmlrpc-endpoint'
ActionController::Base.send(:include,ActionController::Acts::XmlrpcEndpoint )
