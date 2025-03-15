require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  let(:user) { create(:user) }

  describe 'GET #new' do
    context 'when user is not logged in' do
      it 'renders the login page' do
        get :new
        expect(response).to render_template(:new)
      end
    end

    context 'when user is already logged in' do
      before do
        # Simulate a logged in user
        allow(controller).to receive(:logged_in?).and_return(true)
      end

      it 'redirects to workouts index' do
        get :new
        expect(response).to redirect_to('/workouts/index')
      end
    end
  end

  describe 'POST #create' do
    context 'with valid credentials' do
      it 'logs in the user' do
        post :create, params: { 
          session: { 
            email: user.email, 
            password: 'password123' 
          } 
        }
        expect(session[:user_id]).to eq(user.id)
      end

      it 'redirects to root path' do
        post :create, params: { 
          session: { 
            email: user.email, 
            password: 'password123' 
          } 
        }
        expect(response).to redirect_to(root_path)
      end
    end

    context 'with invalid credentials' do
      it 'does not log in the user' do
        post :create, params: { 
          session: { 
            email: user.email, 
            password: 'wrongpassword' 
          } 
        }
        expect(session[:user_id]).to be_nil
      end

      it 'responds with unprocessable entity and redirects to login path' do
        post :create, params: { 
          session: { 
            email: user.email, 
            password: 'wrongpassword' 
          } 
        }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include(login_path)
      end

      it 'sets flash alert message' do
        post :create, params: { 
          session: { 
            email: user.email, 
            password: 'wrongpassword' 
          } 
        }
        expect(flash[:alert]).to eq('Invalid email/password combination')
      end
    end
  end

  describe 'DELETE #destroy' do
    before { session[:user_id] = user.id }

    it 'logs out the user' do
      delete :destroy
      expect(session[:user_id]).to be_nil
    end

    it 'redirects to root path' do
      delete :destroy
      expect(response).to redirect_to(root_path)
    end
  end
end 