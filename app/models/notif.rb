class Notif < ActiveRecord::Base
    has_and_belongs_to_many :appss
end

