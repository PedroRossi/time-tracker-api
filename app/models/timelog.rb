class Timelog < ApplicationRecord
    scope :by_date, -> (date) { where('created_at > ?', Date.parse(date)) }
    validates :description, length: {maximum: 1000} 
    belongs_to :project
    belongs_to :user
end
