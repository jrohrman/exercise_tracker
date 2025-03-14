class SessionsController < ApplicationController
  def new
    if logged_in?
      redirect_to '/workouts/index'
    end
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      session[:user_id] = user.id
      redirect_to root_path, notice: 'Successfully logged in!'
    else
      flash[:alert] = 'Invalid email/password combination'
      redirect_to login_path, status: :unprocessable_entity
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: 'Logged out!'
  end
end 