module Workout
  class Session < ApplicationRecord
    self.table_name = 'workout_sessions'
    
    belongs_to :user
    has_one :workout_type
  end
end
