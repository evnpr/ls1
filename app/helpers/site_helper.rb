module SiteHelper

    def generatepath(r)

    end
    
    def splitpath(r)
        rsplit = r.split("-__-")
        temppath = []
        finalpath = []
        for i in rsplit
            if i == ''
                next
            end
            temppath << i
            path = temppath.join("-__-")
            finalpath << "<a href='/list/?r=#{path}'>#{i}</a>"
        end
        finalpath
    end
    
end

