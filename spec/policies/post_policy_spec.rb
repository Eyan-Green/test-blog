# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PostPolicy, type: :policy do
  let(:admin) { create(:user, :admin) }
  let(:writer) { create(:user, :writer) }

  subject { described_class }

  permissions :show? do
    it 'allows admin users' do
      expect(subject).to permit(admin)
    end
  end

  permissions :create? do
    it 'allows admin users' do
      expect(subject).to permit(admin)
    end
  end

  permissions :update? do
    it 'allows admin users' do
      expect(subject).to permit(admin)
    end
  end

  permissions :destroy? do
    it 'allows admin users' do
      expect(subject).to permit(admin)
    end
  end
end
