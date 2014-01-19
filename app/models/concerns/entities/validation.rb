module Entities::Validation
  extend ActiveSupport::Concern

  included do
    validates :tax_id, :tax_condition, :name, :city_id, presence: true
    validates :tax_id, :tax_condition, :name, length: { maximum: 255 }
    validates :tax_id, :name, uniqueness: { case_sensitive: false, scope: :account_id }
  end
end
