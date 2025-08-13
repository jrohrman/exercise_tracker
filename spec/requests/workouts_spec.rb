require 'rails_helper'

RSpec.describe "Workouts", type: :request do
  let(:user) { create(:user) }
  let(:workout_type) { create(:workout_type) }
  let(:workout_session) { create(:workout_session, user: user, type: workout_type) }

  describe "GET /workouts" do
    it "returns http success" do
      get "/workouts"
      expect(response).to have_http_status(:success)
    end

    it "displays workout sessions in the response" do
      create_list(:workout_session, 3, user: user, type: workout_type)
      
      get "/workouts"
      
      expect(response.body).to include("Workout Sessions")
      expect(response.body).to include(workout_type.name)
    end

    it "displays empty state when no workouts exist" do
      get "/workouts"
      
      expect(response.body).to include("No workout sessions")
      expect(response.body).to include("Get started by creating your first workout session")
    end
  end

  describe "GET /workouts/new" do
    it "returns http success" do
      get "/workouts/new"
      expect(response).to have_http_status(:success)
    end

    it "displays the new workout form" do
      get "/workouts/new"
      
      expect(response.body).to include("Add New Workout Session")
      expect(response.body).to include("Workout Type")
      expect(response.body).to include("Duration (minutes)")
      expect(response.body).to include("Start Time")
      expect(response.body).to include("End Time")
      expect(response.body).to include("Notes")
    end

    it "includes workout types in the form" do
      workout_types = create_list(:workout_type, 3)
      
      get "/workouts/new"
      
      workout_types.each do |type|
        expect(response.body).to include(type.name)
      end
    end
  end

  describe "POST /workouts" do
    let(:valid_params) do
      {
        workout_session: {
          type_id: workout_type.id,
          duration: 45,
          notes: "Great workout today!",
          start_time: 1.hour.ago,
          end_time: 15.minutes.ago
        }
      }
    end

    let(:invalid_params) do
      {
        workout_session: {
          type_id: nil,
          duration: nil,
          notes: "",
          start_time: nil,
          end_time: nil
        }
      }
    end

    context "with valid parameters" do
      it "creates a new workout session" do
        expect {
          post "/workouts", params: valid_params
        }.to change(Workout::Session, :count).by(1)
      end

      it "redirects to workouts index with success message" do
        post "/workouts", params: valid_params
        
        expect(response).to redirect_to(workouts_path)
        expect(flash[:notice]).to eq("Workout session created successfully!")
      end

      it "sets the correct attributes on the created workout" do
        post "/workouts", params: valid_params
        
        workout = Workout::Session.last
        expect(workout.type).to eq(workout_type)
        expect(workout.duration).to eq(45)
        expect(workout.notes).to eq("Great workout today!")
        expect(workout.start_time).to be_present
        expect(workout.end_time).to be_present
      end
    end

    context "with invalid parameters" do
      it "does not create a workout session" do
        expect {
          post "/workouts", params: invalid_params
        }.not_to change(Workout::Session, :count)
      end

      it "renders the new template with unprocessable entity status" do
        post "/workouts", params: invalid_params
        
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("Add New Workout Session")
      end

      it "displays validation errors in the response" do
        post "/workouts", params: invalid_params
        
        expect(response.body).to include("error")
      end
    end
  end

  describe "GET /workouts/:id" do
    it "returns http success" do
      get "/workouts/#{workout_session.id}"
      expect(response).to have_http_status(:success)
    end

    it "displays the workout session details" do
      get "/workouts/#{workout_session.id}"
      
      expect(response.body).to include(workout_session.type.name)
      expect(response.body).to include(workout_session.notes)
    end

    context "when workout session does not exist" do
      it "raises ActiveRecord::RecordNotFound" do
        expect {
          get "/workouts/999999"
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
