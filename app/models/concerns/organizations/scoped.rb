module Organizations::Scoped
  extend ActiveSupport::Concern

  included do
    default_scope -> { where organization_id: Organization.current_id }
  end
end
