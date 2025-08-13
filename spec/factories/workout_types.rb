FactoryBot.define do
  factory :workout_type, class: 'Workout::Type' do
    sequence(:name) { |n| "#{Faker::Sport.name} #{n}" }
    # slug is generated from name in a before validation callback
    description { Faker::Lorem.sentence }
    disabled_at { nil }
  end
end 