class Instruction < ApplicationRecord
  belongs_to :knowhow
  has_one_attached :image
end
