class Apps < ActiveRecord::Base
    belongs_to :user
    has_many :collaborators
    has_one :server
end

