class WorkoutsController < ApplicationController
  def index
    @workouts = Workout.all
  end

  def show
  end

  def create
  end

  def update
  end
end
