class Project < ApplicationRecord
    validates :name, presence: true, length: {maximum: 100}, uniqueness: true
    validates :description, length: {maximum: 500}
    has_many :project_user
    has_many :users, through: :project_user
    has_many :timelogs, dependent: :destroy
end
