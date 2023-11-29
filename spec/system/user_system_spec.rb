# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'User system spec', type: :system do
  let(:admin_instance) { create(:user, :admin) }
  let(:writer_instance) { create(:user, :writer) }

  before(:each) do
    writer_instance
    login_as admin_instance
    MeiliSearch::Rails::Utilities.reindex_all_models
  end

  after(:each) do
    MeiliSearch::Rails::Utilities.clear_all_indexes
  end

  it 'visits users_path, locks writer and is redirected with a flash message' do
    visit users_path
    expect(page).to have_button('Lock')

    click_button 'Lock'
    accept_alert 'Are you sure?'
    expect(page).to have_content('User is now locked!')
    expect(page).to have_current_path(users_path(page: 1))
    expect(page).to have_button('Unlock')
  end

  it 'visits users_path, locks writer and is redirected with a flash message' do
    writer_instance.lock_access!
    visit users_path
    expect(page).to have_button('Unlock')

    click_button 'Unlock'
    accept_alert 'Are you sure?'
    expect(page).to have_content('User is now unlocked!')
    expect(page).to have_current_path(users_path(page: 1))
    expect(page).to have_button('Lock')
  end

  it 'filters users by full_name' do
    create_list(:user, 10, :writer)
    writer_name = User.where(user_type: UserType.find_by(name: 'Writer')).last.full_name
    users = User.where.not(full_name: writer_name)
    visit users_path
    fill_in 'query', with: writer_name
    click_button 'Search'
    expect(page).to have_content(writer_name)
    users.each do |user|
      expect(page).to_not have_content(user.full_name)
    end
  end

  it 'filters users by email' do
    create_list(:user, 10, :writer)
    writer_email = User.where(user_type: UserType.find_by(name: 'Writer')).last.email
    users = User.where.not(email: writer_email)
    visit users_path
    fill_in 'query', with: writer_email
    click_button 'Search'
    expect(page).to have_content(writer_email)
    users.each do |user|
      expect(page).to_not have_content(user.email)
    end
  end
end
