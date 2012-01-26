module Rucursive
  def self.included(base)
    Object.send(:include, Rucursive::CoreExt::Object)
  end

  module CoreExt
    module Object
      def compound?
        is_a?(Array) || is_a?(Hash)
      end

      ##
      # Recursively traverse a compound data structure and call a supplied
      # block on each value or key/value pair, allowing it to modify the
      # returned data structure as it goes. It does NOT modify the existing
      # data structure.
      #
      # Required arguments: A block that is called on each element of the data
      #                     structure
      #
      # Return value: A new data structure including any modifications made by
      #               the supplied block.
      def recurse(&block)
        if is_a?(Array)
          map do |o|
            if o.compound?
              o.recurse(&block)
            else
              block.call(o.dup) if block.arity == 1
              block.call(nil, o.dup) if block.arity == 2
              block.call(nil, o.dup, :array) if block.arity == 3
            end
          end
        elsif is_a?(Hash)
          new_hash = {}
          each_pair do |k,v|
            if v.compound?
              result = block.call(k, v.dup.freeze) if block.arity == 2
              result = block.call(k, v.dup.freeze, :hash) if block.arity == 3
              if result.is_a?(Hash)
                new_key = result.keys.first
              elsif result.is_a?(Array)
                new_key = result.first
              else
                new_key = result
              end
              new_hash[new_key] = v.recurse(&block)
            else
              begin
                v_param = v.dup
              rescue
                v_param = v
              end
              result = block.call(k, v_param) if block.arity == 2
              result = block.call(k, v_param, :hash) if block.arity == 3
              if result.is_a?(Hash)
                new_hash.merge! result
              elsif result.is_a?(Array)
                new_hash[result.first] = result.second
              else
                new_hash[result] = v
              end
            end
          end
          new_hash
        else
          self
        end
      end

      ##
      # Just like Object#recurse when called on a Hash, but only passes the
      # values to the supplied block, rather than the keys and values.
      # Behaves the same as Object#recurse on Arrays.
      def recurse_values(&block)
        if is_a?(Array)
          map do |o|
            if o.compound?
              o.recurse_values(&block)
            else
              block.call o
            end
          end
        elsif is_a?(Hash)
          new_hash = {}
          each_pair do |k,v|
            if v.compound?
              new_hash[k] = v.recurse_values(&block)
            else
              new_hash[k] = block.call v
            end
          end
          new_hash
        else
          self
        end
      end

      ##
      # Just like Object#recurse when called on a Hash, but only passes the
      # keys to the supplied block, rather than the keys and values.
      # Recurses through Arrays looking for Hashes, since Arrays don't really
      # have keys.
      def recurse_keys(&block)
        if is_a?(Array)
          map do |o|
            if o.compound?
              o.recurse_keys(&block)
            else
              o
            end
          end
        elsif is_a?(Hash)
          new_hash = {}
          keys.each do |k|
            new_key = block.call k
            new_hash[new_key] = self[k]
          end
          new_hash.each_pair do |k,v|
            if v.is_a?(Hash)
              new_hash[k] = v.recurse_keys(&block)
            elsif v.is_a?(Array)
              new_ary = v.map do |o|
                o.is_a?(Hash) ? o.recurse_keys(&block) : o
              end
              new_hash[k] = new_ary
            end
          end
          new_hash
        else
          self
        end
      end
    end
  end
end
