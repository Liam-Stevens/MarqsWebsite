class Comment < ApplicationRecord
    belongs_to :submission
    has_one :marker
end
