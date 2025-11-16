# spec/models/user_spec.rb
require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'バリデーション' do
    subject { build(:user) }

    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_most(20) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should validate_length_of(:profile).is_at_most(200) }
  end

  describe 'アソシエーション' do
    it { should have_many(:knowhows).dependent(:destroy) }
    it { should have_many(:purchases).dependent(:destroy) }
    it { should have_one(:payment).dependent(:destroy) }
    it { should have_many(:messages).dependent(:destroy) }
    it { should have_many(:chat_rooms).through(:knowhows) }
    it { should have_one_attached(:avatar) }
  end

  describe '#display_avatar' do
    let(:user) { build(:user) }

    context 'avatar が添付されている場合' do
      let(:user) { build(:user) } # これだけで OK（すでに avatar 添付済み）

      before do
        variant_double = double("variant", processed: :processed_image)
        allow(user.avatar).to receive(:variant).and_return(variant_double)

        allow(Rails.application.routes.url_helpers)
          .to receive(:rails_representation_url)
          .and_return('/variant_avatar.png')
      end

      it 'variant URL を返す' do
        expect(user.display_avatar).to eq('/variant_avatar.png')
      end
    end

    context 'avatar が添付されていない場合' do
      before do
        allow(user.avatar).to receive(:attached?).and_return(false)
      end

      it 'デフォルト画像のパスを返す' do
        expect(user.display_avatar).to eq('/default_avatar.png')
      end
    end
  end

  describe 'コールバック' do
    it 'ユーザー作成後に welcome メールを送信する' do
      user = build(:user)
      expect {
        user.save
      }.to have_enqueued_job(ActionMailer::MailDeliveryJob)
    end
  end
end
