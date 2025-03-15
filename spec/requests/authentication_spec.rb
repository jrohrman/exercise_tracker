require 'rails_helper'

RSpec.describe 'Authentication', type: :request do
  let(:user) { create(:user) }

  describe 'login process' do
    it 'logs in with valid credentials' do
      post login_path, params: { 
        session: { 
          email: user.email, 
          password: 'password123' 
        } 
      }
      expect(session[:user_id]).to eq(user.id)
      expect(response).to redirect_to(root_path)
    end

    it 'fails to log in with invalid credentials' do
      post login_path, params: { 
        session: { 
          email: user.email, 
          password: 'wrongpassword' 
        } 
      }
      expect(session[:user_id]).to be_nil
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include(login_path)
      expect(flash[:alert]).to eq('Invalid email/password combination')
    end
  end

  describe 'logout process' do
    it 'logs out the user' do
      post login_path, params: { 
        session: { 
          email: user.email, 
          password: 'password123' 
        } 
      }
      delete logout_path
      expect(session[:user_id]).to be_nil
      expect(response).to redirect_to(root_path)
    end
  end
end 