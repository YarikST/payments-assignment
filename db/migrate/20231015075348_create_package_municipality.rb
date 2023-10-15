class CreatePackageMunicipality < ActiveRecord::Migration[7.0]
  def change
    create_table :package_municipalities do |t|
      t.references :municipality, null: false, foreign_key: true
      t.references :package, null: false, foreign_key: true

      t.integer :price_cents, null: false, default: 0

      t.timestamps
    end
  end
end