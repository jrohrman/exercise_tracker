FactoryBot.define do
  factory :workout_session, class: 'Workout::Session' do
    association :user
    association :type, factory: :workout_type
    duration { rand(15..120) }
    notes { Faker::Lorem.paragraph(sentence_count: 2) }
    start_time { 1.hour.ago }
    end_time { 30.minutes.ago }
  end
end 