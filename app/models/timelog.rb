class Timelog < ApplicationRecord
    scope :by_date, -> (initial, final) { where('created_at > ? AND created_at < ?', Date.parse(initial), Date.parse(final)) }
    validates :description, length: {maximum: 1000} 
    belongs_to :project
    belongs_to :user
end
