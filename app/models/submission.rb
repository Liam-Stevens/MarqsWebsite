class Submission < ApplicationRecord
    belongs_to :assignment
    has_many :comments
    belongs_to :student
end
