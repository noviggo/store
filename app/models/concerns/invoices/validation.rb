module Invoices::Validation
  extend ActiveSupport::Concern

  included do
    validates :customer, presence: true
  end
end
