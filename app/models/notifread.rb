class Notifread < ActiveRecord::Base
        has_many :notifs
        has_many :users
end

