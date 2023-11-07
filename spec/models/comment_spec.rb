# frozen_string_literal: true

# Spec for comments model
require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'Associations' do
    it 'belongs to user' do
      t = Comment.reflect_on_association(:user)
      expect(t.macro).to eq(:belongs_to)
    end
    it 'belongs to commentable' do
      t = Comment.reflect_on_association(:commentable)
      expect(t.macro).to eq(:belongs_to)
    end
    it 'belongs to parent' do
      t = Comment.reflect_on_association(:parent)
      expect(t.macro).to eq(:belongs_to)
    end
    it 'has many comments' do
      t = Comment.reflect_on_association(:comments)
      expect(t.macro).to eq(:has_many)
    end
  end
end
