require 'rails_helper'

RSpec.describe "Courses API", type: :request do
  describe "GET /courses" do
    it "returns a list of courses with tutors" do

      course = FactoryBot.create(:course, name: "Math")

      FactoryBot.create_list(:tutor, 2, course: course)


      get "/courses"

      expect(response).to have_http_status(:ok)
      response_data = JSON.parse(response.body)
      expect(response_data.length).to eq(1)
      expect(response_data.first["name"]).to eq("Math")
      expect(response_data.first["tutors"].length).to eq(2)
    end
  end

  describe "POST /courses" do
    let(:valid_params) do
      {
        course: {
          name: "Full Stack Development",
          description: "A comprehensive course covering frontend and backend development.",
          tutors_attributes: [
            { name: "John Doe", email: "john.doe@example.com" },
            { name: "Jane Smith", email: "jane.smith@example.com" }
          ]
        }
      }
    end

    it "creates a course with tutors" do
      post "/courses", params: valid_params
      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)["tutors"].size).to eq(2)
    end

    it "returns error for missing course name" do
      post "/courses", params: { course: { name: "" } }
      expect(response).to have_http_status(:unprocessable_entity)

      json = JSON.parse(response.body)
      expect(json["errors"]).to include("Name can't be blank")
    end

    it "returns error if a tutor is missing name" do
      invalid_params = valid_params.deep_dup
      invalid_params[:course][:tutors_attributes][0][:name] = ""

      post "/courses", params: invalid_params
      expect(response).to have_http_status(:unprocessable_entity)

      json = JSON.parse(response.body)
      expect(json["errors"]).to include("Tutors name can't be blank")
    end

    it "returns error if a tutor email is missing" do
      invalid_params = valid_params.deep_dup
      invalid_params[:course][:tutors_attributes][1][:email] = ""
      post "/courses", params: invalid_params
      expect(response).to have_http_status(:unprocessable_entity)

      json = JSON.parse(response.body)
      expect(json["errors"]).to include("Tutors email can't be blank")
    end

    it "creates a course without tutors" do
      params_without_tutors = {
        course: {
          name: "Solo Course",
          description: "Course without tutors"
          # no tutors_attributes key
        }
      }

      post "/courses", params: params_without_tutors
      expect(response).to have_http_status(:created)

      json = JSON.parse(response.body)
      expect(json["tutors"]).to eq([]) # should be empty array
    end

    it "does not allow a tutor to be created with an email that already exists in the database" do
      existing_course = FactoryBot.create(:course)
      existing_tutor = FactoryBot.create(:tutor, email: "existing@example.com", course: existing_course)
      new_course = FactoryBot.create(:course)

      invalid_params = {
        course: {
          name: "New Course",
          description: "Some description",
          tutors_attributes: [
            { name: "New Tutor", email: "existing@example.com" }  # same email as existing tutor
          ]
        }
      }
      post "/courses", params: invalid_params
      expect(response).to have_http_status(:unprocessable_entity)
      json = JSON.parse(response.body)

      expect(json["errors"]).to include("Tutors email is already assigned to another course")
    end
  end
end
