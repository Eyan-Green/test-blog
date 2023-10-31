# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserType, type: :model do
  describe 'Associations' do
    it 'has many users' do
      t = UserType.reflect_on_association(:users)
      expect(t.macro).to eq(:has_many)
    end
  end
end
