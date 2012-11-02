class Notif < ActiveRecord::Base
    has_many :appss
    belongs_to :apps
end

