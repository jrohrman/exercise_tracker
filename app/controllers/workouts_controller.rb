class WorkoutsController < ApplicationController
  def index
    @workout_sessions = Workout::Session.includes(:user, :type).order(created_at: :desc)
  end

  def show
  end

  def create
  end

  def update
  end
end
