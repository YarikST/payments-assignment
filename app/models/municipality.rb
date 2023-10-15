# frozen_string_literal: true

class Municipality < ApplicationRecord
  has_many :package_municipalities, dependent: :destroy
  has_many :packages, through: :package_municipalities

  has_many :prices

  validates :name, presence: true, uniqueness: true
end
