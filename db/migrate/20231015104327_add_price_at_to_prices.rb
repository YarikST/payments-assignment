class AddPriceAtToPrices < ActiveRecord::Migration[7.0]
  def change
    add_column :prices, :price_at, :datetime
  end
end
