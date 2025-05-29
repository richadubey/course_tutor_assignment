class Course < ApplicationRecord
  validates :name, presence: true
  has_many :tutors
end
