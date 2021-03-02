FactoryBot.define do
  factory :answer do
    body { "MyText" }
    question

    trait :invalid do
      body { '' }
    end
  end
end
