module Workout
  class SessionDecorator < SimpleDelegator
    def truncated_notes(length: 50)
      return "No notes" if notes.blank?
      
      if notes.length > length
        "#{notes[0..(length - 1)]}..."
      else
        notes
      end
    end

    def formatted_start_time
      start_time&.strftime("%B %d, %Y at %I:%M %p") || created_at.strftime("%B %d, %Y at %I:%M %p")
    end

    def formatted_duration
      return "Not recorded" unless duration
      
      "#{duration} minute#{duration == 1 ? '' : 's'}"
    end

    def workout_type_name
      type&.name || "Unknown Type"
    end

    def user_email
      user&.email || "Unknown User"
    end
  end 
end