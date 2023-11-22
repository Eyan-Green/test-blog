# frozen_string_literal: true

# Spec for comments model
require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:comment_instance) { create(:comment, parent_id: nil) }
  let(:comment_two) { create(:comment, parent_id: comment_instance.id) }

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

  describe 'Instance methods' do
    it 'returns post' do
      expect(comment_instance.reply_to_comment_or_post).to eq('new_comment_on_post')
    end
    it 'returns comment' do
      expect(comment_two.reply_to_comment_or_post).to eq('new_comment_on_comment')
    end
  end
end
