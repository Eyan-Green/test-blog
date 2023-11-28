# frozen_string_literal: true

# Spec for comments model
require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:comment_instance) { create(:comment, parent_id: nil) }
  let(:comment2) { create(:comment, parent_id: comment_instance.id) }

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
    it 'has a rich text attribute for body' do
      expect(comment_instance).to respond_to(:body)
      expect(comment_instance.body).to be_a(ActionText::RichText)
    end
  end

  describe 'Validations' do
    it 'is invalid without body' do
      comment = Comment.new(body: nil)
      comment.valid?
      expect(comment.errors.full_messages).to include("Body can't be blank")
    end
  end

  describe 'Instance methods' do
    it 'returns post' do
      expect(comment_instance.reply_to_comment_or_post).to eq('new_comment_on_post')
    end
    it 'returns comment' do
      expect(comment2.reply_to_comment_or_post).to eq('new_comment_on_comment')
    end
  end

  describe 'Callbacks' do
    it 'updating a comment triggers after_update_commit' do
      comment_instance
      expect do
        comment_instance.update(body: 'Updated comment')
      end.to have_broadcasted_to(comment_instance.to_gid_param).from_channel(Turbo::StreamsChannel)
    end

    it 'updating a comment triggers after_update_commit' do
      comment = build(:comment, parent: nil)
      expect do
        comment.save
      end.to have_broadcasted_to("#{comment.commentable.to_gid_param}:comments").from_channel(Turbo::StreamsChannel)
    end

    it 'destroying a comment triggers after_destroy_commit with broadcast_remove_to & broadcast_action_to' do
      expect do
        comment_instance.destroy
      end.to have_broadcasted_to(comment_instance.to_gid_param).from_channel(Turbo::StreamsChannel).at_least(2).times
    end
  end
end
