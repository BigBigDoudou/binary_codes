# frozen_string_literal: true

# Role model
class Role < ApplicationRecord
  include RightsConcern

  has_and_belongs_to_many :users
end
