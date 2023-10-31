# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Type, type: :model do
  describe 'Validations' do
    it 'Validate presence of name' do
      type = Type.new(name: nil)
      type.valid?
      expect(type.errors.full_messages).to include('Name can\'t be blank')
    end
  end
end
