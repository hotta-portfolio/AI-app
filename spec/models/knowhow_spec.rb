# spec/models/knowhow_spec.rb
require 'rails_helper'

RSpec.describe Knowhow, type: :model do
  describe 'アソシエーション' do
    it { should belong_to(:user) }
    it { should have_one(:chat_room).dependent(:destroy) }
    it { should have_many(:purchases).dependent(:destroy) }
    it { should have_many(:instructions).dependent(:destroy) }
    it { should accept_nested_attributes_for(:instructions).allow_destroy(true) }
    it { should have_many(:knowhow_tags).dependent(:destroy) }
    it { should have_many(:tags).through(:knowhow_tags) }

    it 'ActiveStorageの添付ファイルを持つ' do
      should have_one_attached(:thumbnail)
      should have_many_attached(:media_files)
    end
  end

  describe 'バリデーション' do
    subject { build(:knowhow) }

    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:category_type) }
    it { should validate_presence_of(:price) }
    it { should validate_numericality_of(:price).only_integer.is_greater_than_or_equal_to(100) }

    context 'step2_submitted が true の場合' do
      before { subject.step2_submitted = true }
      it { should validate_presence_of(:software) }
    end
  end

  describe 'enum' do
    it do
      should define_enum_for(:category_type)
        .with_values(document: 0, video: 1, image: 2, audio: 3)
    end
  end

  describe '#save_tags' do
  let(:user) { create(:user) }
  let(:knowhow) { build(:knowhow, user: user, tag_list: "Rails, Ruby") }

  it 'タグを作成・関連付けする' do
    expect { knowhow.save }.to change { Tag.count }.by(2)
    expect(knowhow.tags.pluck(:name)).to include("Rails", "Ruby")
  end
end

  describe 'ActiveStorage 添付確認' do
    let(:knowhow) { create(:knowhow) }

    it 'thumbnail が添付されている' do
      expect(knowhow.thumbnail).to be_attached
    end

    it 'media_files が複数添付されている' do
      expect(knowhow.media_files.count).to eq(2)
    end
  end
end
