class Assignment < ApplicationRecord
    default_scope {order("due_date ASC")}
    belongs_to :course
    has_many :submissions

    validates :max_points , numericality: {greater_than_or_equal_to: 1, message: "max marks can't be zero"}, allow_nil: false
    validates :weighting , numericality: {greater_than_or_equal_to: 0, less_than_or_equal_to: 1, message: "Mark must be in range (0,1] (greater than 0, less than or equal to 1)"}, allow_nil: false

end
