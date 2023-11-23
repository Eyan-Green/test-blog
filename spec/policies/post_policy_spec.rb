# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PostPolicy, type: :policy do
  let(:admin) { create(:user, :admin) }
  let(:writer) { create(:user, :writer) }
  let(:post) { create(:post, :post_type, user: writer) }
  let(:post2) { create(:post, :post_type, user: admin) }

  subject { described_class }

  permissions :show?, :create? do
    it 'allows admin & writer users' do
      expect(subject).to permit(admin)
      expect(subject).to permit(writer)
    end
  end

  permissions :update?, :destroy? do
    it 'allows admin users' do
      expect(subject).to permit(admin, post)
    end
    it 'allows writer users' do
      expect(subject).to permit(writer, post)
    end
    it 'does not allow writer' do
      expect(subject).to_not permit(writer, post2)
    end
  end
end
