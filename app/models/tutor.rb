class Tutor < ApplicationRecord
  belongs_to :course
  validates :name, presence: true
  validates :email, presence: true, uniqueness: {message: "is already assigned to another course"}
end
