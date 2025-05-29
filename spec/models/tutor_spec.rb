require 'rails_helper'

RSpec.describe Tutor, type: :model do
  let(:course) { Course.create(name: "Physics") }

  it "is valid with valid attributes" do
    tutor = Tutor.new(name: "John Doe", email: "john@example.com", course: course)
    expect(tutor).to be_valid
  end

  it "is not valid without a name" do
    tutor = Tutor.new(name: nil, email: "john@example.com", course: course)
    expect(tutor).not_to be_valid
  end

  it "is not valid without an email" do
    tutor = Tutor.new(name: "John Doe", email: nil, course: course)
    expect(tutor).not_to be_valid
  end

  it "belongs to a course" do
    assoc = Tutor.reflect_on_association(:course)
    expect(assoc.macro).to eq :belongs_to
  end

  it "does not allow a tutor with same email to teach more than one course" do
    Tutor.create!(name: "John Doe", email: "john@example.com", course: course)
    second_course = Course.create(name: "Math")
    duplicate_tutor = Tutor.new(name: "John Different", email: "john@example.com", course: second_course)
    expect(duplicate_tutor).not_to be_valid
    expect(duplicate_tutor.errors[:email]).to include("is already assigned to another course")
  end
end
