module Workout
  class Session < ApplicationRecord
    self.table_name = 'workout_sessions'
    
    belongs_to :user
    belongs_to :type, 
               class_name: 'Workout::Type',
               foreign_key: 'type_id'
  end
end
