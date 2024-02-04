require 'rails_helper'

RSpec.describe "Workouts", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/workouts/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/workouts/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /create" do
    it "returns http success" do
      get "/workouts/create"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /update" do
    it "returns http success" do
      get "/workouts/update"
      expect(response).to have_http_status(:success)
    end
  end

end
