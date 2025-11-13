require 'rails_helper'

RSpec.describe ChatRoom, type: :model do
  describe 'アソシエーション' do
    it { should belong_to(:knowhow) }
    it { should belong_to(:purchase) }
    it { should have_many(:messages).dependent(:destroy) }
  end

  describe '.rooms_for' do
    let(:seller) { create(:user) }
    let(:buyer)  { create(:user) }

    let!(:knowhow_1) { create(:knowhow, user: seller) }
    let!(:knowhow_2) { create(:knowhow, user: seller) }

    let!(:purchase_1) { create(:purchase, user: buyer, knowhow: knowhow_1) }
    let!(:purchase_2) { create(:purchase, user: buyer, knowhow: knowhow_2) }

    let!(:chat_room_1) { create(:chat_room, knowhow: knowhow_1, purchase: purchase_1) }
    let!(:chat_room_2) { create(:chat_room, knowhow: knowhow_2, purchase: purchase_2) }

    context 'roleがbuyerの場合' do
      it '購入者に関連するチャットルームのみ返す' do
        rooms = ChatRoom.rooms_for('buyer', buyer.id)
        expect(rooms).to contain_exactly(chat_room_1, chat_room_2)
      end
    end

    context 'roleがsellerの場合' do
      it '販売者に関連するチャットルームのみ返す' do
        rooms = ChatRoom.rooms_for('seller', seller.id)
        expect(rooms).to contain_exactly(chat_room_1, chat_room_2)
      end
    end

    context 'roleがnilまたはその他の場合' do
      it 'チャットルームを返さない（空）' do
        expect(ChatRoom.rooms_for(nil, buyer.id)).to be_empty
        expect(ChatRoom.rooms_for('unknown', buyer.id)).to be_empty
      end
    end
  end
end
