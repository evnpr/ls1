module SiteHelper

    def generatepath(r)

    end
    
    def splitpath(r)
        rsplit = r.split("-__-")
        temppath = []
        finalpath = []
        for i in rsplit
            temppath << i
            path = temppath.join("-__-")
            if i == ''
                next
            end
            finalpath << "<a href='/list/?r=#{path}' style='font-size: 16px;'>#{i}</a>"
        end
        ret = finalpath.join("/")
        ret.html_safe
    end
    
    def authenticate(apps_owner, apps_id, user_id, username)
        if Collaborator.exists?(:apps_id => apps_id,
                                :user_id => user_id
                                )
            apps_collaborator = Collaborator.where(:apps_id => apps_id, :user_id => user_id).first
        end
        
        unless username == apps_owner or !apps_collaborator.nil?
            redirect_to "/user/index" and return
        end
    end
    
end




