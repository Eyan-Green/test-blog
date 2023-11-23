# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserPolicy, type: :policy do
  let(:admin) { create(:user, :admin) }
  let(:writer) { create(:user, :writer) }

  subject { described_class }

  permissions :index? do
    it 'allows admin and does not allow writer users' do
      expect(subject).to permit(admin)
      expect(subject).to_not permit(writer)
    end
  end

  permissions :toggle_lock? do
    it 'allows admin users' do
      expect(subject).to permit(admin, writer)
    end
    it 'does not allow admin' do
      expect(subject).to_not permit(admin, admin)
    end
  end
end
