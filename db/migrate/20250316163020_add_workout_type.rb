class AddWorkoutType < ActiveRecord::Migration[7.0]
  def change
    create_table :workout_types do |t|
      t.string :name
      t.string :slug
      t.string :description
      t.datetime :disabled_at
    end

    add_reference :workouts, :workout_type, foreign_key: true
  end
end
