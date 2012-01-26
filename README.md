# Rucursive

Adds the #recurse, #recurse_values, and #recurse_keys methods to Object. These
methods allow you to recursively walk complex data structures and modify them.

It returns a new data structure containing your modifications rather than
modifying the original one.

## Installation

    gem install rucursive

## Usage

    require 'rucursive'

    class MyClass
      include Rucursive

      big_hash = {
        :other => {
          "more_stuff" => [1, 2, 3, 4],
          :this_thing => {
            "whoa" => "this is deep"
          }
        },
        :foo => { :bar => 'baz' },
        :qux => ["hello", "world"]
      }

      symbol_keyed_hash = big_hash.recurse do |key, value|
        if key.is_a? String
          key.to_sym
        end
      end
    end

symbol_keyed_hash will then have all symbol keys. In other words, the same keys
and values as big_hash but "more_stuff" and "whoa" will be :more_stuff and :whoa
instead.

## License

MIT License. See LICENSE file.
