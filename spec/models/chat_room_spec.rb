require 'rails_helper'

RSpec.describe ChatRoom, type: :model do
  describe '.rooms_for' do
    subject { ChatRoom.rooms_for(role, user_1.id) }

    let(:role) { nil }
    let(:user_1) { create(:user) }
    let(:user_2) { create(:user) }
    let(:user_3) { create(:user) }
    let(:knowhow_1) { create(:knowhow, user_id: user_1.id) }
    let(:knowhow_2) { create(:knowhow, user_id: user_3.id) }
    let!(:purchase_1) { create(:purchase, user_id: user_1.id, knowhow: knowhow_1) }
    let!(:purchase_2) { create(:purchase, user_id: user_2.id, knowhow: knowhow_2) }
    let!(:purchase_3) { create(:purchase, user_id: user_3.id, knowhow: knowhow_1) }

    it '引数ユーザーが購入か登録したノウハウのチャットルームを登録順の降順で取得する' do
      chat_rooms = subject
      expect(chat_rooms.map { |c| c.class.name }.uniq).to eq %w[ChatRoom]
      expect(chat_rooms.ids).to eq [ purchase_3.chat_room.id, purchase_1.chat_room.id ]
    end

    context '購入者' do
      let(:role) { 'buyer' }

      it '引数ユーザーが購入したノウハウのチャットルームを取得する' do
        expect(subject.ids).to eq [ purchase_1.chat_room.id ]
      end
    end
    context '販売者' do
      let(:role) { 'seller' }

      xit '引数ユーザーが登録したノウハウのチャットルームを取得する' do
        # Pending: データ構造の不備により、ノウハウとチャットルームが １ 対 n になり得るため失敗する。
        expect(subject.ids).to eq [ purchase_1.chat_room.id ]
      end
    end
  end
end
