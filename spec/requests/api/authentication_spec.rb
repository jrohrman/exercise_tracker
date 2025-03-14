require "rails_helper"

RSpec.describe "API Authentication", type: :request do
  before do
    Rails.application.routes.draw do
      get "/api/test" => "test#index"
    end
  end

  after do
    Rails.application.reload_routes!
  end

  describe "when the user provides a valid api token" do
    let(:user) { create(:user) }
    let(:credentials) { "Bearer #{user.token}" }

    it "allows the user to pass" do
      get "/api/test", headers: { "Authorization" => credentials }
      expect(response).to have_http_status(:success)
    end
  end

  context "when the user provides an invalid api token" do
    it "does not allow to user to pass" do
      create(:user, token: "sekkrit")
      credentials = authenticate_with_token("less-sekkrit")

      get "/api/test", headers: { "Authorization" => credentials }

      expect(response).to be_unauthorized
    end
  end

  private

  TestController = Class.new(Api::BaseController) do
    def index
      render json: { message: "Hello world!" }
    end
  end

  def authenticate_with_token(token)
    ActionController::HttpAuthentication::Token.encode_credentials(token)
  end
end