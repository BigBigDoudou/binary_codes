# frozen_string_literal: true

# Rights encoding system
# The encoding/decoding system use binaries and a key (the list) to encode and decode
# The binary number represents the rights, starting from rigth, with 0 == disabled and 1 == enabled
#   for example the binary 001101 (9 in base 10) means that elements at index 0, 2 and 3 are enabled
module RightsConcern
  extend ActiveSupport::Concern

  # Returns the rights as strings
  # @return [Array<string>]
  # @example
  #   7 => ["search", "manage projects", "invite users"]
  def rights
    decode(rights_code)
  end

  # Set rights_code from an array of rights
  # @params value [Array<string>] a list of rights
  # @return [int]
  # @example
  #   ["search", "manage projects", "invite users"] => 7
  def rights=(value)
    self.rights_code = encode(value)
  end

  private

  # List of rights, used as key to encode and decode
  # @return [Array<string>]
  # :nocov:
  def key_list
    %w[alfa bravo charlie delta echo foxtrot golf].freeze
  end
  # :nocov:

  def decode(code)
    # for each elt, check if the corresponding column is 1
    # example with index == 2
    # 0101 -> 0101 >> 2 == 01 -> 01 % 2 == 1 -> add elt
    # 1011 -> 0101 >> 2 == 10 -> 10 % 2 == 0 -> continue
    key_list.select.with_index { |_, i| (code >> i).odd? }
  end

  def encode(elts)
    # sum elt left shifted by positions in #key_list
    # examples:
    # index of elt in #key_list == 0 -> add 1 << 0 == 1
    # index of elt in #key_list == 1 -> add 1 << 1 == 10 (2 in base10)
    # index of elt in #key_list == 2 -> add 1 << 2 == 100 (4 in base10)
    elts.map { |elt| 1 << (key_list.index(elt)) }.sum
  end
end
