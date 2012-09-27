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
            finalpath << "<a href='/list/?r=#{path}' style='font-size: 14px;'>#{i}</a>"
        end
        ret = finalpath.join("/")
        ret.html_safe
    end
    
end



