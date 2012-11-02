class User < ActiveRecord::Base
    has_many :appss
    has_many :userkeys
    has_many :collaborators
    
    has_and_belongs_to_many :notifs
end




