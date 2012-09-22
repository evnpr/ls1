    class Apps < ActiveRecord::Base
    belongs_to :user
    has_many :collaborators
end

