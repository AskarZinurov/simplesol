require "simplesol/version"
require "simplesol/configuration"
require "simplesol/client"

module Simplesol
  extend Configuration

  def debug_message(obj, message)
    p "#{obj.is_a?(Class) ? obj.name : obj.class.name}> #{message}"
  end
  module_function :debug_message
end
