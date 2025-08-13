require 'rails_helper'

RSpec.describe WorkoutsController, type: :controller do
  let(:user) { create(:user) }
  let(:workout_type) { create(:workout_type) }
  let(:workout_session) { create(:workout_session, user: user, type: workout_type) }

  describe "GET #index" do
    before do
      create_list(:workout_session, 3, user: user, type: workout_type)
    end

    it "returns a successful response" do
      get :index
      expect(response).to be_successful
    end

    it "assigns @workout_sessions" do
      get :index
      expect(assigns(:workout_sessions)).to be_present
    end

    it "orders workout sessions by created_at desc" do
      get :index
      expect(assigns(:workout_sessions).first).to eq(Workout::Session.order(created_at: :desc).first)
    end

    it "includes associated user and type" do
      get :index
      expect(assigns(:workout_sessions).first.association(:user).loaded?).to be true
      expect(assigns(:workout_sessions).first.association(:type).loaded?).to be true
    end
  end

  describe "GET #new" do
    context "when user is authenticated" do
      before do
        session[:user_id] = user.id
      end

      it "returns a successful response" do
        get :new
        expect(response).to be_successful
      end

      it "assigns a new workout session" do
        get :new
        expect(assigns(:workout_session)).to be_a_new(Workout::Session)
      end

      it "assigns workout types" do
        workout_types = create_list(:workout_type, 3)
        get :new
        expect(assigns(:workout_types)).to match_array(workout_types)
      end
    end

    context "when user is not authenticated" do
      it "redirects to login" do
        get :new
        expect(response).to redirect_to(login_path)
      end

      it "sets flash alert message" do
        get :new
        expect(flash[:alert]).to eq("Please log in to access this page")
      end
    end
  end

  describe "POST #create" do
    let(:valid_attributes) do
      {
        type_id: workout_type.id,
        duration: 60,
        notes: "Excellent workout session",
        start_time: 1.hour.ago,
        end_time: 30.minutes.ago
      }
    end

    let(:invalid_attributes) do
      {
        type_id: nil,
        duration: nil,
        notes: "",
        start_time: nil,
        end_time: nil
      }
    end

    context "when user is authenticated" do
      before do
        session[:user_id] = user.id
      end

      context "with valid parameters" do
        it "creates a new Workout::Session" do
          expect {
            post :create, params: { workout_session: valid_attributes }
          }.to change(Workout::Session, :count).by(1)
        end

        it "redirects to workouts index" do
          post :create, params: { workout_session: valid_attributes }
          expect(response).to redirect_to(workouts_path)
        end

        it "sets a success notice" do
          post :create, params: { workout_session: valid_attributes }
          expect(flash[:notice]).to eq("Workout session created successfully!")
        end

        it "assigns the created workout session" do
          post :create, params: { workout_session: valid_attributes }
          expect(assigns(:workout_session)).to be_persisted
        end

        it "associates the workout with the current user" do
          post :create, params: { workout_session: valid_attributes }
          expect(assigns(:workout_session).user).to eq(user)
        end

        it "sets the correct attributes on the created workout" do
          post :create, params: { workout_session: valid_attributes }
          
          workout = assigns(:workout_session)
          expect(workout.type_id).to eq(workout_type.id)
          expect(workout.duration).to eq(60)
          expect(workout.notes).to eq("Excellent workout session")
          expect(workout.start_time).to be_present
          expect(workout.end_time).to be_present
        end
      end

      context "with invalid parameters" do
        it "does not create a new Workout::Session" do
          expect {
            post :create, params: { workout_session: invalid_attributes }
          }.not_to change(Workout::Session, :count)
        end

        it "renders the new template" do
          post :create, params: { workout_session: invalid_attributes }
          expect(response).to render_template(:new)
        end

        it "returns unprocessable entity status" do
          post :create, params: { workout_session: invalid_attributes }
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it "assigns workout types for re-rendering" do
          create_list(:workout_type, 2)
          post :create, params: { workout_session: invalid_attributes }
          expect(assigns(:workout_types)).to be_present
        end
      end
    end

    context "when user is not authenticated" do
      it "redirects to login" do
        post :create, params: { workout_session: valid_attributes }
        expect(response).to redirect_to(login_path)
      end

      it "sets flash alert message" do
        post :create, params: { workout_session: valid_attributes }
        expect(flash[:alert]).to eq("Please log in to access this page")
      end

      it "does not create a workout session" do
        expect {
          post :create, params: { workout_session: valid_attributes }
        }.not_to change(Workout::Session, :count)
      end
    end

    context "with missing parameters" do
      before do
        session[:user_id] = user.id
      end

      it "raises ActionController::ParameterMissing" do
        expect {
          post :create, params: {}
        }.to raise_error(ActionController::ParameterMissing)
      end
    end
  end

  describe "GET #show" do
    it "returns a successful response" do
      get :show, params: { id: workout_session.id }
      expect(response).to be_successful
    end

    it "assigns the requested workout session" do
      get :show, params: { id: workout_session.id }
      expect(assigns(:workout_session)).to eq(workout_session)
    end

    context "when workout session does not exist" do
      it "raises ActiveRecord::RecordNotFound" do
        expect {
          get :show, params: { id: 999999 }
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe "strong parameters" do
    before do
      session[:user_id] = user.id
    end

    it "permits only allowed parameters" do
      params = {
        workout_session: {
          type_id: workout_type.id,
          duration: 45,
          notes: "Valid notes",
          start_time: 1.hour.ago,
          end_time: 30.minutes.ago,
          user_id: 999, # Should not be permitted
          created_at: 1.year.ago, # Should not be permitted
          malicious_field: "hack" # Should not be permitted
        }
      }

      post :create, params: params
      
      # Check that only permitted parameters are assigned
      workout = assigns(:workout_session)
      expect(workout.type_id).to eq(workout_type.id)
      expect(workout.duration).to eq(45)
      expect(workout.notes).to eq("Valid notes")
      expect(workout.start_time).to be_present
      expect(workout.end_time).to be_present
      expect(workout.user_id).to eq(user.id)
      expect(workout.created_at).not_to eq(1.year.ago)
    end
  end
end 