require 'rails_helper'

RSpec.describe ChatRoom, type: :model do
  describe '.rooms_for' do
    subject { ChatRoom.rooms_for(role, user_1.id) }

    let(:role) { nil }
    let(:user_1) { create(:user) }
    let(:user_2) { create(:user) }
    let(:user_3) { create(:user) }
    let!(:knowhow_1) { create(:knowhow, user_id: user_1.id) }
    let!(:knowhow_2) { create(:knowhow, user_id: user_2.id) }
    let!(:knowhow_3) { create(:knowhow, user_id: user_3.id) }
    let!(:knowhow_4) { create(:knowhow, user_id: user_1.id) }
    let!(:purchase_1) { create(:purchase, user_id: user_2.id, knowhow: knowhow_1) }
    let!(:purchase_2) { create(:purchase, user_id: user_1.id, knowhow: knowhow_2) }
    let!(:purchase_3) { create(:purchase, user_id: user_3.id, knowhow: knowhow_3) }
    let!(:purchase_4) { create(:purchase, user_id: user_1.id, knowhow: knowhow_2) }

    it '引数ユーザーが購入か登録したノウハウのチャットルームを登録順の降順で取得する' do
      chat_rooms = subject
      expect(chat_rooms.map { |c| c.class.name }.uniq).to eq %w[ChatRoom]
      expect(chat_rooms.ids).to eq [ knowhow_4.chat_room.id, knowhow_2.chat_room.id, knowhow_1.chat_room.id ]
    end

    context '購入者' do
      let(:role) { 'buyer' }

      it '引数ユーザーが購入したノウハウのチャットルームを登録順の降順で取得する' do
        expect(subject.ids).to eq [ knowhow_2.chat_room.id ]
      end
    end
    context '販売者' do
      let(:role) { 'seller' }

      it '引数ユーザーが登録したノウハウのチャットルームを登録順の降順で取得する' do
        expect(subject.ids).to eq [ knowhow_4.chat_room.id, knowhow_1.chat_room.id ]
      end
    end
  end
end
