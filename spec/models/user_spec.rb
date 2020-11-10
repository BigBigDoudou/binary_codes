# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }

  before do
    allow(user).to receive(:list).and_return(%w[a b c d e f])
    user.rights_code = '1001'.to_i(2)
    user.save
    user.roles.create(rights_code: '101010'.to_i(2))
    user.roles.create(rights_code: '000011'.to_i(2))
  end

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

  describe '#full_rights' do
    it 'returns union of self rights and roles rights' do
      expect(user.full_rights).to match_array(%w[a b d f])
    end
  end

  describe '#can?' do
    context 'when user has the right to' do
      it 'returns true' do
        expect(user.can?('a')).to be true
      end
    end

    context 'when user has not the right to' do
      it 'returns false' do
        expect(user.can?('c')).to be false
      end
    end
  end
end
