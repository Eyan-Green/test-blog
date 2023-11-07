# frozen_string_literal: true

# Likes helper spec
require 'rails_helper'
RSpec.describe LikesHelper, type: :helper do
  describe 'Like helper methods' do
    let(:like) { create(:like) }
    let(:current_user) { like.user }
    let(:post) { create(:post, :post_type) }

    it 'returns unlike HTML when record is already liked' do
      response = "<span class=\"translation_missing\" title=\"translation missing: en.Unlike\">Unlike</span>"
      expect(like_button_text(like.record)).to eq(response)
    end
    it 'returns like HTML when record has not been liked' do
      response = "<span class=\"translation_missing\" title=\"translation missing: en.Like\">Like</span>"
      expect(like_button_text(post)).to eq(response)
    end
  end
end
