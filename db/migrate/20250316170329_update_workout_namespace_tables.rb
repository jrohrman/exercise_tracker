class UpdateWorkoutNamespaceTables < ActiveRecord::Migration[7.0]
  def change
    rename_table :workouts, :workout_sessions

    # Update foreign key relationship
    remove_foreign_key :workout_sessions, :workout_types
    rename_column :workout_sessions, :workout_type_id, :type_id
    add_foreign_key :workout_sessions, :workout_types, column: :type_id

    # Add any missing columns from your original workouts table
    add_column :workout_sessions, :user_id, :bigint unless column_exists?(:workout_sessions, :user_id)
    add_column :workout_sessions, :duration, :integer unless column_exists?(:workout_sessions, :duration)
    add_column :workout_sessions, :notes, :text unless column_exists?(:workout_sessions, :notes)
    add_column :workout_sessions, :start_time, :datetime unless column_exists?(:workout_sessions, :start_time)
    add_column :workout_sessions, :end_time, :datetime unless column_exists?(:workout_sessions, :end_time)

    # Add indexes
    add_index :workout_sessions, :user_id unless index_exists?(:workout_sessions, :user_id)
    add_index :workout_sessions, :type_id unless index_exists?(:workout_sessions, :type_id)
  end
end
