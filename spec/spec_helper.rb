$LOAD_PATH.unshift(File.join(File.basename(__FILE__), '..', 'lib'))
require 'rucursive'

RSpec.configure do |c|
  c.mock_with :mocha
end
