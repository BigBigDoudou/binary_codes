# frozen_string_literal: true

# Abstract ActiveRecord class
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
