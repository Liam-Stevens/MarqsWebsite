class Submission < ApplicationRecord
  belongs_to :assignment
  has_many :comments
  belongs_to :student

  #Validates that grade is within range
  validates :grade , numericality: {greater_than_or_equal_to: 0, message: "grade must be a non-negative number"}, allow_nil: true
  validate :grade_cannot_be_greater_than_max


  def grade_cannot_be_greater_than_max 
      if (!grade.nil? && !assignment.max_points.nil? && grade > assignment.max_points) 
          errors.add(:grade, student_id.to_s + "'s grade can't be greater than max points: " + assignment.max_points.to_s)
      end
  end

  def self.to_csv(data)
      attributesReal = %w{student_id grade nil content}
      attributesDummy = %w{StudentID Fix-Final-Mark Feedback-Mark Feedback-Comments}
  
      CSV.generate(headers: true) do |csv|
        csv << attributesDummy
  
        data.each do |value|
            csv << value.attributes.values_at(*attributesReal)
        end
      end
  end
end