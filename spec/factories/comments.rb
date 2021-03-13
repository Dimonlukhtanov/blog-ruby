FactoryBot.define do
  factory :comment do
    username { 'MyUsername' }
    body { 'MyText' }
    post { nil }
  end
end
