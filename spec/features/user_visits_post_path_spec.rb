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

  scenario 'They are redirected to /posts' do
    create_list(:post, 30, :post_type)
    visit '/posts?page=10000'
    expect(current_path).to eq('/posts')
  end

  scenario 'Valid create' do
    visit new_post_path

    expect(page).to have_field 'post_title'

    fill_in 'Title', with: 'Title'
    select('Tech', from: 'post_post_type_id')
    fill_in_trix_editor 'post_content_trix_input_post', with: 'Post content!'
    click_button 'Create Post'

    expect(current_path).to eq("/posts/#{Post.last.id}")
    expect(page).to have_content('Post was successfully created.')
    expect(page).to have_content('Title')
    expect(page).to have_content('Post content!')
  end

  scenario 'Valid create' do
    visit new_post_path

    expect(page).to have_field 'post_title'
    fill_in 'Title', with: ''
    fill_in_trix_editor 'post_content_trix_input_post', with: ''

    click_button 'Create Post'

    expect(page).to have_content('Post could not be created, please try again.')
    expect(page).to have_content("Title can't be blank")
    expect(page).to have_content("Content can't be blank")
  end

  scenario 'They fill out edit form and click on submit' do
    visit edit_post_path(instance)

    fill_in 'Title', with: 'Updated Title'
    click_button 'Update Post'

    expect(page).to have_content('Updated Title')
    expect(page).to have_content('Post was successfully updated.')
    expect(current_path).to eq(post_path(instance))
  end

  scenario 'Invalid update' do
    visit edit_post_path(instance)

    fill_in 'Title', with: ''
    click_button 'Update Post'

    expect(page).to have_content('Post could not be updated, please try again.')
    expect(page).to have_content("Title can't be blank")
  end

  scenario 'click on like and text changes to Unlike' do
    visit post_path(instance)
    click_button 'Like'
    expect(page).to have_content('Unlike')
  end

  scenario 'User adds a comment' do
    visit post_path(instance)

    fill_in_trix_editor "post_#{instance.id}_new_comment_body_trix_input_comment", with: 'Post comment'
    click_button 'Submit'

    expect(page).to have_content('Post comment')
  end
end
