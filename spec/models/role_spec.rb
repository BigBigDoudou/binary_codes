# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Role, type: :model do
  subject { build(:role) }

  describe 'factory' do
    it 'has operating factory' do
      expect(create(:role)).to be_valid
    end

    it 'has operating factory (trait :with_users)' do
      expect(create(:role, :with_users)).to be_valid
    end
  end

  describe 'associations' do
    it { is_expected.to have_and_belong_to_many(:users) }
  end
end
