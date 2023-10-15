# frozen_string_literal: true

class UpdatePackagePrice
  # options [Hash]
  #   municipality [String]
  def self.call(package, new_price_cents, **options)
    raise ArgumentError.new('A municipality name is omitted') unless options[:municipality_name]

    Package.transaction do
      municipality = Municipality.find_or_create_by(name: options[:municipality_name])
      package_municipality = municipality.package_municipalities.find_or_create_by(package: package) do |new_package_municipality|
        new_package_municipality.price_at = DateTime.current
      end

      unless package_municipality.previously_new_record?
        # Add a pricing history record
        Price.create!(
          package: package,
          price_cents: package.price_for(options[:municipality_name]),
          municipality: municipality,
          price_at: package_municipality.price_at
        )
      end

      # Update the current price
      package_municipality.update!(price_cents: new_price_cents, price_at: DateTime.current)
    end
  end
end
