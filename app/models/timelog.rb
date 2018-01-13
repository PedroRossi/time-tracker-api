class Timelog < ApplicationRecord
    validates :description, length: {maximum: 1000} 
    belongs_to :project
    belongs_to :user
end
