class Apps < ActiveRecord::Base
    belongs_to :user
    has_many :collaborators
    has_one :server
    has_one :thedatabase
    has_and_belongs_to_many :notifs
    has_many :updateapps
end



