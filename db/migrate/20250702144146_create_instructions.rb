class CreateInstructions < ActiveRecord::Migration[8.0]
  def change
    create_table :instructions do |t|
      t.integer :step
      t.text :description
      t.references :knowhow, null: false, foreign_key: true

      t.timestamps
    end
  end
end
