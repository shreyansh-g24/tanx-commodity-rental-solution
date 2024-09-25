class CreateCommodities < ActiveRecord::Migration[7.2]
  def change
    create_table :commodities do |t|
      t.string :name, null: false
      t.string :description
      t.string :category, null: false
      t.references :user, foreign_key: true, index: true, null: false

      t.timestamps
    end
  end
end
