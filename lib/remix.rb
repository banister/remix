direc = File.dirname(__FILE__)

require 'rbconfig'
require "#{direc}/remix/version"

dlext = Config::CONFIG['DLEXT']

begin
    if RUBY_VERSION && RUBY_VERSION =~ /1.9/
        require "#{direc}/1.9/remix.#{dlext}"
    else
        require "#{direc}/1.8/remix.#{dlext}"
    end
rescue LoadError => e
    require "#{direc}/remix.#{dlext}"
end

