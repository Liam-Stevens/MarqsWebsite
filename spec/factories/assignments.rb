FactoryBot.define do
    factory :assignment do
        title {"Example Assignment"}
        max_points { 100 }
        weighting { 0.5 }
        course
    end
end
