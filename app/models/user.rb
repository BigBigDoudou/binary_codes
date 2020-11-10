# frozen_string_literal: true

# User model
class User < ApplicationRecord
  include RightsConcern

  has_and_belongs_to_many :roles

  # Returns union of self rights and roles rights
  # @return [int]
  # @example
  #   7
  def full_rights_code
    roles.pluck(:rights_code).push(rights_code).reduce(:|)
  end

  # Returns list of union of self rights and roles rights
  # @return [Array<string>]
  # @example
  #   ["search", "manage projects", "invite users"]
  def full_rights
    list.select.with_index { |_, i| (full_rights_code >> i).odd? }
  end
end
