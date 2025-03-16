module Workout
  class Type < ApplicationRecord
    self.table_name = 'workout_types'
    
    has_many :sessions, 
             class_name: 'Workout::Session',
             foreign_key: 'type_id'

    validates :name, presence: true, uniqueness: true
    validates :slug, uniqueness: true

    before_validation :generate_slug

    private

    def generate_slug
      return if name.blank?
      
      self.slug = name.downcase.gsub('-', ' ').parameterize(separator: '_')
    end
  end
end