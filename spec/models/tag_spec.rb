# spec/models/tag_spec.rb
require 'rails_helper'

RSpec.describe Tag, type: :model do
  describe 'アソシエーション' do
    it { should have_many(:knowhow_tags).dependent(:destroy) }
    it { should have_many(:knowhows).through(:knowhow_tags) }
  end

  describe '.ransackable_attributes' do
    it '指定されたカラムを返す' do
      expect(Tag.ransackable_attributes).to eq(%w[id name created_at updated_at])
    end
  end
end
