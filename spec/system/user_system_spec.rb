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
end
