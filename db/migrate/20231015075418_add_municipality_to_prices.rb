class AddMunicipalityToPrices < ActiveRecord::Migration[7.0]
  def change
    add_reference :prices, :municipality, index: true
  end
end
