# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Notification system spec', type: :system do
  let(:notification_instance) { create(:notification) }

  before(:each) do
    notification_instance
    login_as notification_instance.user
  end

  it 'visits root_path and clicks on notification bell' do
    visit root_path
    expect(page).to have_selector('#notification_counter')
    find('#notification_counter').click_button
    expect(page).to have_button('Mark as read')
    within '#notification_count' do
      expect(page).to have_text('1')
    end
    click_button 'Mark as read'
    within '#notification_count' do
      expect(page).to have_text('0')
    end
    expect(page).to have_button('Delete All Notifications')
    click_button 'Delete All Notification'
    accept_alert 'Are you sure?'
    expect(page).to have_text 'Notifications deleted!'
    find('#notification_counter').click_button
    expect(page).to have_text 'You currently have no notifications.'
  end
end
