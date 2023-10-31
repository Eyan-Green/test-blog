# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PostType, type: :model do
  describe 'Associations' do
    it 'has many posts' do
      t = PostType.reflect_on_association(:posts)
      expect(t.macro).to eq(:has_many)
    end
  end
end
