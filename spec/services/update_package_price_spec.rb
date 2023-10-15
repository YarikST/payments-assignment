# frozen_string_literal: true

require "spec_helper"

RSpec.describe UpdatePackagePrice do
  PackageWithMunicipality = Struct.new(:package, :municipality, :package_municipality, keyword_init: true)
  def create_package_with_municipality(package_name:, municipality_name:, price_cents:)
    package = Package.create!(name: package_name)
    municipality = Municipality.create!(name: municipality_name)
    package_municipality = package.package_municipalities.create!(municipality: municipality, price_cents: price_cents)

    PackageWithMunicipality.new(package: package, municipality: municipality, package_municipality: package_municipality)
  end

  it "updates the current price of the provided package" do
    package = Package.create!(name: "Dunderhonung")
    municipality_name = "Göteborg"

    UpdatePackagePrice.call(package, 200_00, municipality_name: municipality_name)
    expect(package.price_for(municipality_name)).to eq(200_00)
  end

  it "only updates the passed package price" do
    factory = create_package_with_municipality(
      package_name: "Dunderhonung",
      municipality_name: "Göteborg",
      price_cents: 100_00
    )
    other_municipality_name = "Jönköping"

    expect {
      UpdatePackagePrice.call(factory.package, 200_00, municipality_name: other_municipality_name)
    }.not_to change {
      factory.package_municipality.reload.price_cents
    }
  end

  it "stores the old price of the provided package in its price history" do
    factory = create_package_with_municipality(
      package_name: "Dunderhonung",
      municipality_name: "Göteborg",
      price_cents: 100_00
    )

    UpdatePackagePrice.call(factory.package, 200_00, municipality_name: "Göteborg")
    expect(factory.package.prices).to be_one
    price = factory.package.prices.first
    expect(price.price_cents).to eq(100_00)
  end

  # This tests covers feature request 1. Feel free to add more tests or change
  # the existing one.

  it "supports adding a price for a specific municipality" do
    package = Package.create!(name: "Dunderhonung")

    UpdatePackagePrice.call(package, 200_00, municipality_name: "Göteborg")

    # You'll need to implement Package#price_for
    expect(package.price_for("Göteborg")).to eq(200_00)
  end
end
