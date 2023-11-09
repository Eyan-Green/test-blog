require 'rails_helper'

RSpec.describe CommentMailer, type: :mailer do
  describe '#new_comment' do
    let(:user_instance) { create(:user, :writer) }
    let(:post_instance) { create(:post, :post_type) }

    let(:mail) { CommentMailer.with(user: user_instance, post: post_instance).new_comment.deliver_now }

    it 'renders the headers correctly' do
      expect(mail.subject).to eq('New comment on your post')
      expect(mail.to).to eq([user_instance.email])
      expect(mail.from).to eq(['no-reply@test-blog.com'])
    end

    it 'renders the body with user and post information' do
      expect(mail.body.encoded).to match(user_instance.full_name)
      expect(mail.body.encoded).to match(post_instance.title)
    end
  end
end
