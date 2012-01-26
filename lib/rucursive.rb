require "rucursive/version"
require "rucursive/core_ext"

module Rucursive
  def self.included(base)
    Object.send :include, Rucursive::CoreExt::Object
  end
end
