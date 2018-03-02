class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def pretty_errors
    errors.full_messages.join('. ') << '.' if errors.any?
  end
end
