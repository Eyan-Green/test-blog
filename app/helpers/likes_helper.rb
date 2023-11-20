# frozen_string_literal: true

# Likes helper
module LikesHelper
  def like_button_text(record)
    record.liked_by?(current_user) ? t('Unlike') : t('Like')
  end
end
