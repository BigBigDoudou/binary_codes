# frozen_string_literal: true

# User model
class User < ApplicationRecord
  include RightsConcern

  has_and_belongs_to_many :roles

  # user rights
  # union with user roles rights if inherited == true
  def rights(inherited: false)
    his = attributes['rights']
    binaries =
      if inherited
        roles.pluck(:rights).push(his).reduce(:|)
      else
        his
      end
    decode(binaries)
  end
end
