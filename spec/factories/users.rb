# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    rights_code { 4 + 16 }

    trait :with_roles do
      after(:create) do |user|
        user.roles.create(attributes_for(:role))
      end
    end
  end
end
