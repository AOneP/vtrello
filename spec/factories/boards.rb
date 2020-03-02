FactoryBot.define do
  factory :board, class: Board do
    title { 'FactoryTitle' }
    describe { 'FactoryDescribe' }
    background_color { 10 }
  end
end
