require 'rails_helper'

RSpec.describe Knowhow, type: :model do
  describe 'callbacks' do
    subject { knowhow.save! }

    let(:knowhow) { build(:knowhow, user:, tag_list: tag_list) }
    let(:user) { create(:user) }
    let(:tag_list) { '' }

    it { is_expected.to be_truthy }

    describe 'tag_list' do
      let(:tag_list) { 'タグ_A,タグ_B' }

      it '引数の tag_list に該当する Tag が登録される' do
        subject
        expect(knowhow.tags.pluck(:name)).to match_array(%w[タグ_A タグ_B])
      end

      context 'tag_list が nil' do
        let(:tag_list) { nil }

        it { is_expected.to be_truthy }
      end

      context 'tag_list が 数値' do
        let(:tag_list) { 1 }

        it { expect { subject }.to raise_error(NoMethodError) }
      end
    end
  end
end
