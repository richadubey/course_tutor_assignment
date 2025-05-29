class Course < ApplicationRecord
  validates :name, presence: true
  has_many :tutors
  accepts_nested_attributes_for :tutors
end
