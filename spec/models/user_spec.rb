# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }

  describe 'factory' do
    it 'has operating factory' do
      expect(create(:user)).to be_valid
    end

    it 'has operating factory (trait :with_roles)' do
      expect(create(:user, :with_roles)).to be_valid
    end
  end

  describe 'associations' do
    it { is_expected.to have_and_belong_to_many(:roles) }
  end

  describe '#rights' do
    before do
      allow(user).to receive(:list).and_return(%w[a b c d e f])
      user.rights_code = '1001'.to_i(2)
      user.save
      user.roles.create(rights_code: '101010'.to_i(2))
      user.roles.create(rights_code: '000011'.to_i(2))
    end

    describe '#full_rights_code' do
      it 'returns union of self rights and roles rights' do
        expect(user.full_rights_code).to eq '101011'.to_i(2)
      end
    end

    describe '#full_rights' do
      it 'returns union of self rights and roles rights' do
        expect(user.full_rights).to match_array(%w[a b d f])
      end
    end
  end
end
