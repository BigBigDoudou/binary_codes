# frozen_string_literal: true

FactoryBot.define do
  factory :role do
    rights_code { 1 + 2 + 32 }

    trait :with_users do
      after(:create) do |role|
        role.users.create(attributes_for(:user))
      end
    end
  end
end
