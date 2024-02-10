FactoryBot.define do
  factory :model do
    title { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
    status { 'pending' }
  end
end
