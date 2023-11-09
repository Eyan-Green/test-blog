# frozen_string_literal: true

require 'rails_helper'

feature 'User visits post path' do
  let(:instance) { create(:post, :post_type) }
  let(:user_instance) { create(:user, :admin) }

  before(:each) do
    create(:user_type, :writer)
    create(:post_type, :tech)
    user_instance
    login_as user_instance
  end

  scenario 'They see the title and content' do
    visit post_path(instance)

    expect(page).to have_content(instance.title)
    expect(page).to have_content(instance.content.to_plain_text)
  end

  scenario 'Invalid create' do
    visit new_post_path

    expect(page).to have_field 'post_title'

    fill_in 'Title', with: 'Title'
    select('Tech', from: 'post_post_type_id')

    expect(current_path).to eq(new_post_path)
  end

  scenario 'They fill out edit form and click on submit' do
    visit edit_post_path(instance)

    fill_in 'Title', with: 'Updated Title'
    click_button 'Update Post'

    expect(page).to have_content('Updated Title')
    expect(page).to have_content('Post was successfully updated.')
    expect(current_path).to eq(post_path(instance))
  end

  scenario 'click on like and text changes to Unlike' do
    visit post_path(instance)
    click_button 'Like'
    expect(page).to have_content('Unlike')
  end
end
