require 'rails_helper'

RSpec.describe Course, type: :model do
  it "is valid with valid attributes" do
    course = Course.new(name: "Mathematics")
    expect(course).to be_valid
  end

  it "is not valid without a name" do
    course = Course.new(name: nil)
    expect(course).not_to be_valid
  end

  it "has many tutors" do
    assoc = Course.reflect_on_association(:tutors)
    expect(assoc.macro).to eq :has_many
  end
end
