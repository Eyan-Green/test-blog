# frozen_string_literal: true

# Record helper spec
require 'rails_helper'
RSpec.describe RecordHelper, type: :helper do
  let(:post) { create(:post, :post_type) }
  let(:comment) { create(:comment) }

  describe 'Record helper methods' do
    it 'returns path for comment nested in post' do
      response = "post_#{post.id}_comment_#{comment.id}"
      expect(dom_id_for_records(post, comment)).to eq(response)
    end
    it 'returns path for comment nested in post with a custom prefix' do
      response = "prefix_post_#{post.id}_prefix_comment_#{comment.id}"
      expect(dom_id_for_records(post, comment, prefix: 'prefix')).to eq(response)
    end
  end
end
