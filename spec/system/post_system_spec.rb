# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Post system spec', type: :system do
  let(:user_instance) { create(:user, :admin) }
  let(:post_instance) { create(:post, :post_type) }

  before(:each) do
    create(:post_type, :tech)
    login_as user_instance
    MeiliSearch::Rails::Utilities.reindex_all_models
  end

  after(:each) do
    MeiliSearch::Rails::Utilities.clear_all_indexes
  end

  it 'creates a new post' do
    visit new_post_path

    fill_in 'Title', with: 'Title'

    expect(page).to have_selector('.customized-max-width')

    page.execute_script("document.querySelector('.customized-max-width').innerHTML = 'Hello <em>world!</em>';")

    click_button 'Create Post'

    expect(page).to have_content('Post was successfully created.')
    expect(page).to have_current_path(post_path(Post.last))
    expect(page).to have_content('Title')
    expect(page).to have_content('Hello world!')
    expect(Post.last.title).to eq('Title')
    expect(Post.last.content.body.to_s).to include('Hello <em>world!</em>')
  end
  it 'displays validation errors when content is blank' do
    visit new_post_path
    fill_in 'Title', with: 'Title'
    click_button 'Create Post'
    expect(page).to have_content("Content can't be blank")
    expect(page).to have_content('Post could not be created, please try again.')
  end

  it 'updates an existing post' do
    visit edit_post_path(post_instance)

    fill_in 'Title', with: 'Title Updated'

    expect(page).to have_selector('.customized-max-width')

    page.execute_script("document.querySelector('.customized-max-width').innerHTML = 'Hello <em>world!</em> This has now been updated!';")

    click_button 'Update Post'

    expect(page).to have_content('Post was successfully updated.')
    expect(page).to have_current_path(post_path(Post.last))
    expect(page).to have_content('Title Updated')
    expect(page).to have_content('Hello world! This has now been updated!')
    expect(Post.last.title).to eq('Title Updated')
    expect(Post.last.content.body.to_s).to include('Hello <em>world!</em> This has now been updated!')
  end

  it 'displays validation errors when content is blank on update' do
    visit edit_post_path(post_instance)
    fill_in 'Title', with: 'Title'
    page.execute_script("document.querySelector('.customized-max-width').innerHTML = '';")
    click_button 'Update Post'
    expect(page).to have_content("Content can't be blank")
    expect(page).to have_content('Post could not be updated, please try again.')
  end

  it 'likes post' do
    visit post_path(post_instance)
    click_button 'Like'
    expect(page).to have_content('Unlike')
  end

  it 'unlikes post' do
    visit post_path(post_instance)
    click_button 'Like'
    click_button 'Unlike'
    expect(page).to have_content('Like')
  end

  it 'filters index page by title' do
    post_instance
    create(:post, :post_type, title: 'Something different')
    visit posts_path
    expect(page).to have_field('query')
    fill_in 'query', with: 'Something different'
    click_button 'Search'
    expect(page).to have_content('Something different')
    expect(page).to_not have_selector('h2#Title')
  end

  it 'filters by user' do
    post_instance
    user = create(:user, :writer)
    create(:post, :post_type, title: 'Something different', user: user)
    visit posts_path
    expect(page).to have_field('query')
    fill_in 'query', with: user.full_name
    click_button 'Search'
    expect(page).to have_content('Something different')
    expect(page).to_not have_selector('h2#Title')
  end

  it 'filters by post type' do
    post_instance
    post_type = create(:post_type, name: 'Health')
    create(:post, title: 'Something different', post_type: post_type)
    visit posts_path
    expect(page).to have_field('query')
    fill_in 'query', with: post_type.name
    click_button 'Search'
    expect(page).to have_content('Something different')
    expect(page).to_not have_selector('h2#Title')
  end

  it 'filters by comment text' do
    post_instance.update(title: 'Google')
    create(:comment)
    create(:post, :post_type, title: 'Something different')
    visit posts_path
    expect(page).to have_field('query')
    fill_in 'query', with: 'This is a comment'
    click_button 'Search'
    expect(page).to have_content('Something different')
    expect(page).to_not have_selector('h2#Google')
  end

  it 'filters by post content text' do
    post_instance
    create(:comment)
    create(:post, :post_type, content: 'Some text', title: 'Different')
    visit posts_path
    expect(page).to have_field('query')
    fill_in 'query', with: 'Some text'
    click_button 'Search'
    expect(page).to have_content('Some text')
    expect(page).to_not have_selector('h2#Title')
  end
end
