# frozen_string_literal: true

# Rights encoding system
# The encoding/decoding system use binaries and a key (the list) to encode and decode
# The binary number represents the rights, starting from rigth, with 0 == disabled and 1 == enabled
#   for example the binary 001101 (9 in base 10) means that elements at index 0, 2 and 3 are enabled
module RightsConcern
  extend ActiveSupport::Concern

  # List of rights, used as key to encode and decode
  # @return [Array<string>]
  def list
    %w[
      right_0
      right_1
      right_2
      right_3
      right_4
      right_5
    ].freeze
  end

  # Returns an code from an array
  # @return [int]
  # @example
  #   ["search", "manage projects", "invite users"] #=> 7
  def rights
    # for each option, check if the corresponding column is 1
    # example with index == 2
    # 0101 -> 0101 >> 2 == 01 -> 01 % 2 == 1 -> add option
    # 1011 -> 0101 >> 2 == 10 -> 10 % 2 == 0 -> continue
    list.select.with_index { |_, i| (rights_code >> i).odd? }
  end

  # Save rights (integer) from an array of strings
  # @params value [Array<string>] a list of rights
  # @return [int]
  # @example
  #   ["search", "manage projects", "invite users"] => 7
  def rights=(value)
    # sum right left shifted by positions in #list
    # examples:
    # index of right in #list == 0 -> add 1 << 0 == 1
    # index of right in #list == 1 -> add 1 << 1 == 10 (2 in base10)
    # index of right in #list == 2 -> add 1 << 2 == 100 (4 in base10)
    self.rights_code = value.map { |right| 1 << (list.index(right)) }.sum
  end
end
