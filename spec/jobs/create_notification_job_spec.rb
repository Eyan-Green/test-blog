# spec/jobs/create_notification_job_spec.rb
require 'rails_helper'

RSpec.describe CreateNotificationJob, type: :job do
  include ActiveJob::TestHelper

  let(:user) { create(:user, :admin) }
  let(:commentable) { create(:post, :post_type) }
  let(:comment) { create(:comment, user: create(:user, :writer), parent_id: nil) }

  it 'queues the job' do
    expect {
      CreateNotificationJob.perform_later(user.id, commentable, comment)
    }.to have_enqueued_job(CreateNotificationJob)
      .on_queue('default')
  end

  it 'executes perform with correct arguments' do
    notification_service_instance = instance_double(NotificationService)
    allow(NotificationService).to receive(:new).and_return(notification_service_instance)
    allow(notification_service_instance).to receive(:create_new_notification)

    perform_enqueued_jobs do
      CreateNotificationJob.perform_later(user.id, commentable, comment)
    end

    expect(NotificationService).to have_received(:new).with(user, commentable, comment.reply_to_comment_or_post)
    expect(notification_service_instance).to have_received(:create_new_notification)
  end
end
