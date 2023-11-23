# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CommentPolicy, type: :policy do
  let(:admin) { create(:user, :admin) }
  let(:writer) { create(:user, :writer) }
  let(:comment) { create(:comment, user: writer) }
  let(:comment2) { create(:comment, user: admin) }

  subject { described_class }

  permissions :show?, :create? do
    it 'allows admin & writer users' do
      expect(subject).to permit(admin)
      expect(subject).to permit(writer)
    end
  end

  permissions :update?, :destroy? do
    it 'allows admin users' do
      expect(subject).to permit(admin, comment)
    end
    it 'allows writer users' do
      expect(subject).to permit(writer, comment)
    end
    it 'does not allow writer users' do
      expect(subject).to_not permit(writer, comment2)
    end
  end
end
