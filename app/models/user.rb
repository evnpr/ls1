class User < ActiveRecord::Base
    has_many :appss
    has_many :userkeys
end

