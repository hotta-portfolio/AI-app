require 'rails_helper'

RSpec.describe Purchase, type: :model do
  describe 'アソシエーション' do
    it { should belong_to(:user) }
    it { should belong_to(:knowhow) }
    it { should have_one(:chat_room).dependent(:destroy) }
  end
end
