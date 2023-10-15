class RemovePriceCentsFromPackages < ActiveRecord::Migration[7.0]
  def change
    remove_column :packages, :price_cents
  end
end
