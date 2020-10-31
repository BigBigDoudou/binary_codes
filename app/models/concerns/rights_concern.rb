# frozen_string_literal: true

module RightsConcern
  extend ActiveSupport::Concern

  RIGHTS = %w[
    manage_users
    manage_projects
    connect_api
    search
  ].freeze
  private_constant :RIGHTS

  # returns rights as array of strings
  def rights
    decode(attributes['rights'])
  end

  # save rights (integer) from an array of strings
  def rights=(value)
    super(encode(value))
  end

  private

  # Returns an code from an array
  # @param code Array<String> the elements to encode
  # @example
  #   ["alfa", "bravo", "charlie", "echo"] #=> 153
  def encode(elements)
    # sum element left shifted by positions in RIGHTS
    # examples:
    # index of element in RIGHTS == 0 -> add 1 << 0 == 1
    # index of element in RIGHTS == 1 -> add 1 << 1 == 10 (2 in base10)
    # index of element in RIGHTS == 2 -> add 1 << 2 == 100 (4 in base10)
    elements.map { |element| 1 << (RIGHTS.index(element)) }.sum
  end

  # Returns an array from a code
  # @param code <Integer> the code the decode
  # @example
  #   153 #=> ["alfa", "bravo", "charlie", "echo"]
  def decode(code)
    # for each option, check if the corresponding column is 1
    # example with index == 2
    # 0101 -> 0101 >> 2 == 01 -> 01 % 2 == 1 -> add option
    # 1011 -> 0101 >> 2 == 10 -> 10 % 2 == 0 -> continue
    RIGHTS.select.with_index { |_, i| (code >> i).odd? }
  end
end
