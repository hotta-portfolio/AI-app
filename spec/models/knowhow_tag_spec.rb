# spec/models/knowhow_tag_spec.rb
require 'rails_helper'

RSpec.describe KnowhowTag, type: :model do
  describe 'アソシエーション' do
    it { should belong_to(:knowhow) }
    it { should belong_to(:tag) }
  end
end
