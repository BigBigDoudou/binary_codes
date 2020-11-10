# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.integer :rights_code, default: 0

      t.timestamps
    end
  end
end
