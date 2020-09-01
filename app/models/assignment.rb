class Assignment < ApplicationRecord
    default_scope {order("due_date ASC")}
    belongs_to :course
    has_many :submissions
end
