require 'spec_helper'

describe Rucursive::CoreExt do
  describe Rucursive::CoreExt::Object do
    context "top-level Object class" do
      it "should respond to #compound?" do
        Object.new.should respond_to(:compound?)
      end

      it "should respond to #recurse" do
        Object.new.should respond_to(:recurse)
      end
    end

    describe "#compound?" do
      it "should return true for a Hash" do
        Hash.new.should be_compound
      end

      it "should return true for an Array" do
        Array.new.should be_compound
      end

      it "should return false for a String" do
        String.new.should_not be_compound
      end

      it "should return false for a Fixnum" do
        1.should_not be_compound
      end
    end

    describe "#recurse" do
      it "should call the block on every key,value pair in a Hash" do
        hash = { foo: 'bar', baz: 'qux', gabba: { key1: 'val1', key2: 'val2' } }
        expectation = hash.expects(:recurse)
        hash.each_pair do |k,v|
          expectation.yields(k).yields(v)
        end
        hash[:gabba].each_pair do |k,v|
          expectation.yields(k).yields(v)
        end
        hash.recurse { |k,v| }
      end

      it "should call the block on every item in an array" do
        ary = [ :foo, 42, 'bar', [ :baz, 0, 'qux' ] ]
        expectation = ary.expects(:recurse)
        ary.each do |o|
          expectation.yields(o)
        end
        ary[3].each do |o|
          expectation.yields(o)
        end
        ary.recurse { |o| }
      end

      it "should call the block on everything in a complex data structure" do
        data = {
          foo: [ 1, 2, 3, { 4 => 5, 6 => 7 } ],
          bar: {
            colors: [
              {'red' => 'green'},{'yellow' => 'violet'},{'blue' => 'orange'}
            ],
            cars: {
              good: ['Altima', 'Prius', 'Volt'],
              bad: ['Suburban', 'Excursion', 'Grand Cherokee']
            }
          }
        }
        expectation = data.expects(:recurse)
        data.each_pair do |k,v|
          expectation.yields(k).yields(v)
        end
        data[:foo].each do |o|
          expectation.yields(o)
        end
        data[:foo][3].each do |k,v|
          expectation.yields(k).yields(v)
        end
        data[:bar].each_pair do |k,v|
          expectation.yields(k).yields(v)
        end
        data[:bar][:colors].each do |c|
          expectation.yields(c)
          c.each_pair do |k,v|
            expectation.yields(k).yields(v)
          end
        end
        data[:bar][:cars].each do |k,v|
          expectation.yields(k).yields(v)
          v.each do |c|
            expectation.yields(c)
          end
        end
        data.recurse { |k,v| }
      end
    end

    # TODO: Add tests for recurse_values & recurse_keys

  end
end
