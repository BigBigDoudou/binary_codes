# frozen_string_literal: true

# User model
class User < ApplicationRecord
  include RightsConcern

  has_and_belongs_to_many :roles

  # Returns list of union of self rights and roles rights
  # @return [Array<string>]
  # @example
  #   ["search", "manage projects", "invite users"]
  def full_rights
    decode(full_rights_code)
  end

  # Checks if the user has the right
  # @param [string] the right to check
  # @return [Boolean]
  def can?(right)
    (full_rights_code & encode([right])).positive?
  end

  private

  # Returns union of self rights and roles rights
  # @return [int]
  # @example
  #   7
  def full_rights_code
    roles.pluck(:rights_code).push(rights_code).reduce(:|)
  end
end
