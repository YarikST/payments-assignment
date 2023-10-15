# frozen_string_literal: true

class PriceHistory
  def self.call(package:, year:, municipality_name: nil)
    scope = Municipality.joins(prices: :package)

    scope = scope.where(packages: package)
    scope = scope.where("prices.price_at >= ? AND prices.price_at <= ?",
                        DateTime.new(year).beginning_of_year, DateTime.new(year).end_of_year )
    scope = scope.where(name: municipality_name) if municipality_name
    scope = scope.group(:name)
    scope = scope.pluck(Arel.sql("municipalities.name, json_group_array(prices.price_cents)"))

    scope.to_h.transform_values { |price_cents_as_string| JSON.parse(price_cents_as_string) }
  end
end
