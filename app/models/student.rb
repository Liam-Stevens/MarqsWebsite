class Student < ApplicationRecord
    has_and_belongs_to_many :courses
    has_many :submission, dependent: :destroy

    # Helper to concatenate name
    def full_name
        return first_name + " " + last_name
    end
end
