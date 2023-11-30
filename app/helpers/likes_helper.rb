# frozen_string_literal: true

# app/helpers/likes_helper.rb
module LikesHelper
  def like_button_text(record)
    record.liked_by?(current_user) ? t('Unlike') : t('Like')
  end

  def blue_or_red(record)
    record.liked_by?(current_user) ? 'bg-red-300 hover:bg-red-400' : 'bg-blue-300 hover:bg-blue-400'
  end
end
