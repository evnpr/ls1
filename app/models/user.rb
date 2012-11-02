class User < ActiveRecord::Base
    has_many :appss
    has_many :userkeys
    has_many :collaborators
    
    belongs_to :notifread
end




