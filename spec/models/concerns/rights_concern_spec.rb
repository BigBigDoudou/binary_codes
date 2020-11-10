# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RightsConcern do
  let(:role) { build(:role) }

  describe 'rights' do
    before do
      allow(role).to receive(:list).and_return(%w[a b c d e f])
    end

    describe '#rights' do
      it 'returns decoded rights list' do
        role.rights_code = '101101'.to_i(2)
        expect(role.rights).to match_array(%w[a c d f])
      end
    end

    describe '#rights=(value)' do
      it 'sets rights_code from a rights list' do
        role.rights_code = 0
        role.rights = %w[a c d f]
        expect(role.rights_code.to_s(2)).to eq '101101'
      end
    end
  end
end
