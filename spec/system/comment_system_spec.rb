# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Comment system spec', type: :system do
  let(:user_instance) { create(:user, :admin) }
  let(:post_instance) { create(:post, :post_type) }

  before(:each) do
    create(:post_type, :tech)
    login_as user_instance
  end

  it 'valid create' do
    visit post_path(post_instance)

    expect(page).to have_selector('.comments-text-editor')
    page.execute_script("document.querySelector('.comments-text-editor').innerHTML = 'Hello <em>world!</em>';")

    click_button 'Submit'

    expect(page).to have_content('Hello world!')
    expect(Comment.last.body.body.to_s).to include('Hello <em>world!</em>')
  end

  it 'invalid create' do
    visit post_path(post_instance)

    click_button 'Submit'

    expect(page).to have_content("Body can't be blank")
  end

  it 'valid update' do
    visit post_path(post_instance)

    page.execute_script("document.querySelector('.comments-text-editor').innerHTML = 'Hello <em>world!</em>';")

    click_button 'Submit'

    expect(page).to have_content('Hello world!')
    expect(Comment.last.body.body.to_s).to include('Hello <em>world!</em>')

    click_link 'Edit'
    page.execute_script("document.querySelector('.comments-text-editor').innerHTML = 'Hello <em>world!</em> Updated';")
    click_button 'Submit'
    expect(page).to have_content('Hello world! Updated')
    expect(Comment.last.body.body.to_s).to include('Hello <em>world!</em> Updated')
  end

  it 'invalid update' do
    visit post_path(post_instance)

    page.execute_script("document.querySelector('.comments-text-editor').innerHTML = 'Hello <em>world!</em>';")

    click_button 'Submit'

    expect(page).to have_content('Hello world!')
    expect(Comment.last.body.body.to_s).to include('Hello <em>world!</em>')

    click_link 'Edit'
    page.execute_script("document.querySelector('.comments-text-editor').innerHTML = '';")
    click_button 'Submit'
    expect(page).to have_content("Body can't be blank")
  end
end
