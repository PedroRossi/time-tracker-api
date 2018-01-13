class User < ApplicationRecord
    validates :name, presence: true, length: {maximum: 100}
    validates :email, presence: true, uniqueness: true
    has_many :project_user
    has_many :projects, through: :project_user
    has_many :timelogs, dependent: :destroy
end
