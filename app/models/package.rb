# frozen_string_literal: true

class Package < ApplicationRecord
  has_many :package_municipalities, dependent: :destroy
  has_many :municipalities, through: :package_municipalities
  has_many :prices, dependent: :destroy

  validates :name, presence: true, uniqueness: true

  def price_for(municipality_name)
    package_municipality = package_municipalities
                             .joins(:municipality)
                             .where(municipalities: { name: municipality_name })
                             .take

    return 0 unless package_municipality

    package_municipality.price_cents
  end
end
