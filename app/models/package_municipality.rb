# frozen_string_literal: true

class PackageMunicipality < ApplicationRecord
  belongs_to :municipality
  belongs_to :package

  validates :price_cents, presence: true
end
