FactoryBot.define do
  factory :workout_type, class: 'Workout::Type' do
    name { Faker::Sport.name }
    # slug is generated from name in a before validation callback
    description { Faker::Lorem.sentence }
    disabled_at { nil }
  end
end 