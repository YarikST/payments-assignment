class AddPackageMunicipalitiesToPrices < ActiveRecord::Migration[7.0]
  def change
    add_column :package_municipalities, :price_at, :datetime
  end
end
