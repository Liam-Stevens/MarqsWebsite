

class Submission < ApplicationRecord
    belongs_to :assignment
    has_many :comments
    belongs_to :student

    #Validates that grade is within range
    validates :grade , numericality: {greater_than_or_equal_to: 0}, allow_nil: true
    validate :grade_cannot_be_greater_than_max

    def grade_cannot_be_greater_than_max 
        if (!grade.nil? && grade > assignment.max_points) 
            errors.add(:grade, "Can't be greater than max points: " + assignment.max_points.to_s)
        end
        
    end
end
