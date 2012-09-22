class Collaborator < ActiveRecord::Base
    belongs_to :user
    belongst_to :apps
end

