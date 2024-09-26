class CreateListingsAndBids < ActiveRecord::Migration[7.2]
  def change
    # Create listings
    create_table :listings do |t|
      t.references :commodity, foreign_key: true, index: true, null: false
      t.string :status, null: false
      t.string :selection_strategy, null: false
      t.float :quote_price_per_month, default: 0, null: false

      t.timestamps
    end

    # Create bids
    create_table :bids do |t|
      t.references :user, foreign_key: true, index: true, null: false
      t.references :listing, foreign_key: true, index: true, null: false
      t.float :price_per_month, default: 0, null: false
      t.integer :number_of_months, default: 0, null: false

      t.timestamps
    end

    # For 1 user, for 1 listing there can be only 1 bid
    add_index :bids, [ :user_id, :listing_id ], unique: true

    # Add selected_bid to listings
    add_reference :listings, :selected_bid, foreign_key: { to_table: :bids }, null: true, index: { unique: true }
  end
end
