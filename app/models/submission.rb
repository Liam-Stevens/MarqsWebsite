class Submission < ApplicationRecord
    belongs_to :assignment
    has_many :comments
    belongs_to :student
    # validates :grade , numericality: {greater_than_or_equal_to: 0}
end
