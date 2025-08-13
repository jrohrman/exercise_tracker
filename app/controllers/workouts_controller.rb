class WorkoutsController < ApplicationController
  before_action :require_login, only: [:new, :create, :update]

  def index
    @workout_sessions = Workout::Session.includes(:user, :type).order(created_at: :desc)
  end

  def new
    @workout_session = Workout::Session.new
    @workout_types = Workout::Type.all.order(:name)
  end

  def show
    @workout_session = Workout::Session.find(params[:id])
  end

  def create
    @workout_session = Workout::Session.new(workout_params)
    @workout_session.user = current_user
    
    if @workout_session.save
      redirect_to workouts_path, notice: 'Workout session created successfully!'
    else
      @workout_types = Workout::Type.all
      render :new, status: :unprocessable_entity
    end
  end

  def update
  end

  private

  def workout_params
    params.require(:workout_session).permit(:type_id, :duration, :notes, :start_time, :end_time)
  end
end
