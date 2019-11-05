FactoryBot.define do
  factory :task do
    project
    name { Faker::Marketing.buzzwords }
    description { Faker::Lorem.sentence }
  end
end
