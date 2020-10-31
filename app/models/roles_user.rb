# frozen_string_literal: true

# RolesUser model
class RolesUser < ApplicationRecord
  belongs_to :role
  belongs_to :user
end
