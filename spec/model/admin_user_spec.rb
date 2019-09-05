# frozen_string_literal: true

RSpec.describe AdminUser, type: :model do
  let!(:admin_user) { create :admin_user }

  describe 'Creation' do
    let!(:admin_user) { build :admin_user }

    it 'Fabrics' do
      expect(admin_user).to be_valid
    end
  end
end
