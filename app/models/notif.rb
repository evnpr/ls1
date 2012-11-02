class Notif < ActiveRecord::Base
    has_and_belongs_to_many :appss
    has_and_belongs_to_many :users
    belongs_to :notifread
end



