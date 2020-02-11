class ApplicationRecord < ActiveRecord::Base
  has_paper_trail

  self.abstract_class = true

  def self.filtered_list(query)
    query.present? ? unicode_search(query) : all
  end
end
