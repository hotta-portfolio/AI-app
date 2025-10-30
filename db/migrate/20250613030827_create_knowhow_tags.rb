class CreateKnowhowTags < ActiveRecord::Migration[8.0]
  def change
    create_table :knowhow_tags do |t|
      t.references :knowhow, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true

      t.timestamps
    end
  end
end
