# spec/models/instruction_spec.rb
require 'rails_helper'

RSpec.describe Instruction, type: :model do
  describe 'associations' do
    it { should belong_to(:knowhow) }
    it { should have_one_attached(:image) }
  end

  describe 'validations' do
    it { should validate_presence_of(:description) }

    it "画像必須のバリデーションが動く" do
      instruction = build(:instruction)
      instruction.image.detach   # 画像を外す
      expect(instruction).not_to be_valid
      expect(instruction.errors[:image]).to include("画像をアップロードしてください")
    end
  end
end
