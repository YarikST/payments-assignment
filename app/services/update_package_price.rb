# frozen_string_literal: true

class UpdatePackagePrice
  # options [Hash]
  #   municipality [String]
  def self.call(package, new_price_cents, **options)
    raise ArgumentError.new('A municipality name is omitted') unless options[:municipality_name]

    Package.transaction do
      municipality = Municipality.find_or_create_by(name: options[:municipality_name])

      # Add a pricing history record
      Price.create!(package: package, price_cents: package.price_for(options[:municipality_name]), municipality: municipality)

      # Update the current price
      package_municipality = municipality.package_municipalities.find_or_create_by(package: package)
      package_municipality.update!(price_cents: new_price_cents)
    end
  end
end
