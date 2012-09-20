                require 'zip/zip'
class SiteController < ApplicationController
  before_filter :get_users
  
  def get_users
    @username = cookies[:username] 
  end
  
  @@directory = "/var/www/ls/upload"
  

  
  def index
    if @username
        redirect_to "/user/index"
    end
  end

  def upload
    user_name = @username
    apps_name = params[:name].downcase.delete(" ")
    virtual_name = params[:name]
    database_name = params[:database_name]
    database_username = params[:database_username]
    database_pwd = params[:databasepwd]


    if Apps.exists?(:name => apps_name) then
        flash[:create_apps] = "the name is already used, choose another name"
        redirect_to "/user/index" and return
    end

    `mkdir #{@@directory}/#{apps_name}`
    a = Apps.new(:name => apps_name)
    a.virtual_name = virtual_name
    a.user_id = User.where(:username => user_name).first.id
    a.save

    unless database_name.nil? || database_name == ''
        sql = ActiveRecord::Base.connection();
        sql.execute("DROP DATABASE IF EXISTS " + database_name + ";");
        sql.execute("CREATE DATABASE IF NOT EXISTS " + database_name + ";");
        sql.execute("GRANT ALL ON " + database_name + ".* TO " + database_username + "@localhost IDENTIFIED BY '" + database_pwd +"';");
    end


    gitdirectory = "/home/git/repositories"

    Dir.chdir("/var/www/ls/res/gitosis-admin"){
        open("/var/www/ls/res/gitosis-admin/gitosis.conf", "a") do |f|
            f.puts "\n"
            f.puts "[group g#{apps_name}]\n"
            f.puts "writable = #{apps_name} \n"
            f.puts "members = evan@evan-Lenovo ls #{user_name}@#{user_name} \n"
        end
        `ruby push.rb`
    }



    Dir.chdir("#{@@directory}/#{apps_name}"){
        `git init`
        `git add .`
        `git commit -m 'welcome to letspan'`
        `git remote add lsorigin2 git@letspan.com:#{apps_name}.git`
        `git push lsorigin2 master`
        `sudo chmod -R 777 #{@@directory}/#{apps_name}`
        `sudo chmod -R 777 #{gitdirectory}/#{apps_name}.git/`
        `sudo cp #{gitdirectory}/post-receive #{gitdirectory}/#{apps_name}.git/hooks/` 
        `sudo sed -i 's/appsname /#{apps_name} /g' #{gitdirectory}/#{apps_name}.git/hooks/post-receive`
    }


    redirect_to '/list/?r=-__-'+apps_name and return

  end

  def list
    unless @username
        redirect_to "/" and return
    end
    if(request.GET[:r].nil? || request.GET[:r]=='') then
        redirect_to "/user/index" and return
    #    @listfolder = Dir.glob("#{@@directory}/*/").sort
    #    if session[:ls1].nil?
    #        @listfolder = @listfolder - ["#{@@directory}/ls1/"]
    #    end
    #    @listfile = {}
    #    return
    end
    @root = 'pull'
    r = request.GET[:r]
    back = r.split("-__-")
    @apps_name = back[1]
    unless Apps.exists?(:name => @apps_name)
        redirect_to "/" and return
    end
    unless back
        redirect_to "/" and return
    end        
    apps_owner = Apps.where(:name => @apps_name).first.user.username
    if @username != apps_owner
        redirect_to "/user/index" and return
    end
    back.pop
    @back = back.join("-__-")
    path = r.gsub(/\-\_\_\-/, "\/")
    @name = path
    @listfolder = Dir.glob("#{@@directory}/#{@name}/*/").sort
    listfile = Dir.glob("#{@@directory}/#{@name}/*")
    listfolderfile = Dir.glob("#{@@directory}/#{@name}/*/").collect { |x| ; x.chop }
    @listfile = (listfile - listfolderfile).sort
    @current_path = r 
    @done = 'done rsync!'
  end


  def listapps
    if(request.GET[:r].nil?) then
        @listfolder = Dir.glob("#{@@directory}/*/").sort
        @listfile = {}
    end
  end


  def showcontent
    unless @username
        redirect_to "/" and return
    end
    r = request.GET[:r]
    @r = r 
    @current_path = r
    back = r.split("-__-")
    @apps_name = back[1]
    unless Apps.exists?(:name => @apps_name)
        redirect_to "/" and return
    end
    unless back
        redirect_to "/" and return
    end     
    apps_owner = Apps.where(:name => @apps_name).first.user.username
    if @username != apps_owner
        redirect_to "/user/index" and return
    end
    back.pop
    @back = back.join("-__-")
    path = r.gsub(/\-\_\_\-/, "\/")
    language = r.split(".").last
    case language
        when "php"
            @language = "php"
        when "py"
            @language = "python"
        when "js"
            @language = "javascript"
        when "coffee"
            @language = "ruby"
        when "css"
            @language = "css"
        when "rb"
            @language = "ruby"
        when "jpg"
            `cp #{@@directory}/#{path} /var/www/ls/upload/img/#{r}`
            @image = "http://dev.img.letspan.com/#{r}"
        when "png"
            `cp #{@@directory}/#{path} /var/www/ls/upload/img/#{r}`
            @image = "http://dev.img.letspan.com/#{r}"
        when "gif"
            `cp #{@@directory}/#{path} /var/www/ls/upload/img/#{r}`
            @image = "http://dev.img.letspan.com/#{r}"
        else
            @language = "html"
    end
    if File.exists?("#{@@directory}/#{path}")
        file = File.open("#{@@directory}/#{path}", "rb")
        @contents = file.read
    end
    @done = 'done rsync!'
    @path = path
    render :layout => 'editor'
  end


  def showcontentvim
    unless @username
        redirect_to "/"
    end
    @title = 'Letspan!'
    r = request.GET[:r]
    @r = r 
    back = r.split("-__-")
    @apps_name = back[1]
    back.pop
    @back = back.join("-__-")
    path = r.gsub(/\-\_\_\-/, "\/")
    @language = r.split(".").last
    if File.exists?("#{@@directory}/#{path}")
        file = File.open("#{@@directory}/#{path}", "rb")
        @contents = file.read
    end
    filetxt = Rails.root.join("public/ace-editor/kitchen-sink/docs/file.#{@language}")
    `touch #{filetxt}`
    file = File.open((filetxt), "w")
    file.write(@contents)
    file.close
    @path = path
    render "showcontentvim", :layout => 'editorvim' and return
  end

  def savecontent
    unless @username
        redirect_to "/"
    end
    r = params[:thisfile]
    commit = params[:commit]
    apps_name = r.split("-__-")[1]
    path = r.gsub(/\-\_\_\-/, "\/")
    `sudo chmod -R 777 #{@@directory}/#{path}`
    file = File.open("#{@@directory}/#{path}", "w")
    c = params[:content]
    content = c.gsub("\r",'')
    file.write(content)
    file.close
    `sudo chmod -R 777 #{@@directory}/#{apps_name}`
    Dir.chdir(@@directory+"/"+apps_name){
        `git add .`
        `git commit -m '#{commit}'`
        `git push lsorigin2 master -f`
        if apps_name == 'ls1'
            `git remote add lsdev ubuntu@letspan.com:/home/ubuntu/git-www/devletspan`
            `git push lsdev master -f`
        end
    }
    redirect_to "/content?r="+r and return
  end

  def github
    unless @username
        redirect_to "/"
    end
    r = params[:r]
    back = r.split("-__-")
    apps_name = back[1]
    back.pop
    r = back.join("-__-")
    path = r.gsub(/\-\_\_\-/, "\/")
    if(request.GET[:g].nil?) then
        Dir.chdir(@@directory+"/#{path}"){
           # `git remote add lsorigin git@github.com:#{username}/#{namerepos}.git`
        }
    end
    Dir.chdir(@@directory+"/#{apps_name}"){
        `git add .`
        `git commit -m 'push from ls'`
        `git push lsorigin master -f`
    }

    redirect_to "/content?r="+params[:r] and return
  end


  def githubpull
    unless @username
        redirect_to "/"
    end
    path = params[:l]
    from = params[:r]
    username = 'evnpr'
    namerepos = 'lst'
    #`git remote add lsorigin git@github.com:#{username}/#{namerepos}.git`
    Dir.chdir(@@directory+"/#{path}"){
        `git pull lsorigin master -f`
    }
    redirect_to "#{from}" and return
  end


  def bitbucket 
    r = params[:r]
    username = 'evnpr'
    namerepos = 'ls1'
    back = r.split("-__-")
    back.pop
    r = back.join("-__-")
    path = r.gsub(/\-\_\_\-/, "\/")
    if(request.GET[:g].nil?) then
        Dir.chdir(@@directory+"/#{path}"){
            `git remote add lsbitbucket git@bitbucket.org:#{username}/#{namerepos}.git`
        }
    end
    Dir.chdir(@@directory+"/#{path}"){
        `git add .`
        `git commit -m 'push from ls'`
        `git push lsbitbucket master -f`
    }

    redirect_to "/content?r="+params[:r] and return
  end

  def bitbucketpull
    path = params[:l]
    from = params[:r]
    username = 'evnpr'
    namerepos = 'lst'
    `git remote add lsbitbucket git@bitbucket.org:#{username}/#{namerepos}.git`
    Dir.chdir(@@directory+"/#{path}"){
        `git pull lsbitbucket master -f`
    }
    redirect_to "#{from}" and return
  end


  def gitnew 
    unless @username
        redirect_to "/" and return
    end
    if request.post?
        user_name = @username
        publickey = params[:key]
        if user_name.nil? or publickey == ''
            redirect_to "/site/gitnew" and return
        end
        temprorary_res = '/var/www/ls/res/gitosis-admin/keydir/'+user_name+'@'+user_name+'.pub'
        publickeysample = publickey[3..-220].to_s()
        p = Userkey.where("userkey LIKE ?", '%'+publickeysample+'%').first
        if p then
            flash[:gitnew] = "the key already used"
            redirect_to "/site/gitnew" and return
        end
        u = User.where(:username => user_name).first
        uk = Userkey.new(:user_id => u.id, :userkey => publickey)
        uk.save
        if File.exists?("#{temprorary_res}")
            open(temprorary_res, "a") do |f|
                f.puts "\n"
                f.puts "#{publickey}"
            end
        else
         #   if Userkey.exists?(:user_id => u.id)
         #       mykeys = User.where(:username => @username).first.userkeys
         #       mykeys.each do |k|
         #           if File.exists?("#{temprorary_res}")
         #               open(temprorary_res, "a") do |f|
         #                   f.puts "\n"
         #                   f.puts "#{k.userkey}"
         #               end
         #           else
         #               `touch #{temprorary_res}`
         #               file = File.open(temprorary_res, "w")
         #               file.write(k.userkey)
         #               file.close
         #           end
         #       end 
         #   else 

                `touch #{temprorary_res}`
                file = File.open(temprorary_res, "w")
                file.write(publickey)
                file.close

         #   end
        end
        Dir.chdir("/var/www/ls/res/gitosis-admin"){
            `ruby push.rb`
        }
        redirect_to "/site/gitnew" and return
    else
        if User.exists?(:username => @username)
            @key = User.where(:username => @username).first.userkeys
        end
    end
  end

  def gitdelete
    unless @username
        redirect_to "/site/index" and return
    end
    
    keyid = params[:id]
    if Userkey.exists?(:id => keyid)
        owner = Userkey.find(keyid).user.username
    end
    if @username != owner
        redirect_to "/site/gitnew" and return
    end

    temprorary_res = '/var/www/ls/res/gitosis-admin/keydir/'+@username+'@'+@username+'.pub'
    `sudo rm #{temprorary_res}`
    Userkey.find(keyid).destroy
    mykeys = User.where(:username => @username).first.userkeys
    mykeys.each do |k|
        if File.exists?("#{temprorary_res}")
            open(temprorary_res, "a") do |f|
                f.puts "\n"
                f.puts "#{k.userkey}"
            end
        else
            `touch #{temprorary_res}`
            file = File.open(temprorary_res, "w")
            file.write(k.userkey)
            file.close
        end
    end 

    Dir.chdir("/var/www/ls/res/gitosis-admin"){
        `ruby push.rb`
    }

  end


  def githubnew 
    unless @username
        redirect_to "/" and return
    end   
    if request.post?
        apps_name = params[:apps_name]
        yourname = params[:githubname]
        yourproject = params[:githubrepo]
        if Apps.exists?(:githubname => yourname, :githubproject => yourproject)
            flash[:githubnew] = "name and project already exists"
            redirect_to "/site/githubnew" and return
        end
        Dir.chdir(@@directory+"/"+apps_name){
           `git init`
           `git remote rm lsorigin`
           `git remote add lsorigin git@github.com:#{yourname}/#{yourproject}.git`
           u = Apps.where(:name => apps_name).first
           u.githubname = yourname
           u.githubproject = yourproject
           u.save
        }
        redirect_to "/site/githubnew" and return
    else
        if User.exists?(:username => @username)
            @apps = User.where(:username => @username).first.appss
        end
    end
  end

  def newfile
    r = params[:r]
    newfile = params[:newfile]
    dirfolder = r.gsub(/\-\_\_\-/, "\/")
    `touch #{@@directory}/#{dirfolder}/#{newfile}`
    redirect_to "/list?r="+params[:r] and return
  end

  def newfolder
    r = params[:r]
    newfolder = params[:newfolder]
    dirfolder = r.gsub(/\-\_\_\-/, "\/")
    `mkdir #{@@directory}/#{dirfolder}/#{newfolder}`
    redirect_to "/list?r="+params[:r] and return
  end

  def renamefile
    r = params[:r]
    apps_name = r.split("-__-")[1]
    oldfile = params[:oldfile]
    n = params[:newfile]
    dirfolder = r.gsub(/\-\_\_\-/, "\/")
    path = r.gsub(/\-\_\_\-/, "\/")+"/"
    lengthdirectory = r.split("-__-").length
    accessbackfrom = oldfile.scan("..").length
    accessbackto = n.scan("..").length
    if lengthdirectory-accessbackfrom < 2
        flash[:list] = "permission denied"
        redirect_to "/list?r="+params[:r] and return
    elsif lengthdirectory-accessbackto < 2 
        flash[:list] = "permission denied"
        redirect_to "/list?r="+params[:r] and return    
    end
    #`sudo mv #{@@directory}#{dirfolder}/#{oldfile} #{@@directory}#{dirfolder}/#{n}`
    `sudo rm -R #{@@directory}#{dirfolder}/#{oldfile}`
    Dir.chdir(@@directory+"/"+apps_name){
        `git add .`
        `git commit -m 'rename #{oldfile} to #{n}'`
        `git push lsorigin2 master -f`
        if apps_name == 'ls1'
            `git remote add lsdev ubuntu@letspan.com:/home/ubuntu/git-www/devletspan`
            `git push lsdev master -f`
        end
    }
    redirect_to "/list?r="+params[:r] and return
  end

  def uploadfile
      r = params[:r]
      apps_name = r.split("-__-")[1]
      dirfolder = r.gsub(/\-\_\_\-/, "\/")
      uploaded_files = params[:thefile]
      if uploaded_files.nil?
        flash[:list] = "you are not uploading any folder/files"
        redirect_to "/list?r="+params[:r] and return
      end
      uploaded_files.each do |u|
          File.open("#{@@directory}/#{dirfolder}/"+u.original_filename, 'wb') do |file|
            file.write(u.read)
            file.close
          end
      end
      Dir.chdir(@@directory+"/"+apps_name){
        `git add .`
        `git commit -m 'upload file #{uploaded_files}'`
        `git push lsorigin2 master -f`
        if apps_name == 'ls1'
            `git remote add lsdev ubuntu@letspan.com:/home/ubuntu/git-www/devletspan`
            `git push lsdev master -f`
        end
      }
      redirect_to "/list?r="+params[:r] and return
  end
  
  def uploadfolder
      r = params[:r]
      apps_name = r.split("-__-")[1]
      dirfolder = r.gsub(/\-\_\_\-/, "\/")
      uploaded_io = params[:thefile]
      if uploaded_io.nil?
        flash[:list] = "you are not uploading any folder/files"
        redirect_to "/list?r="+params[:r] and return
      end
      checkzip = uploaded_io.original_filename.scan(".zip").length
      if checkzip < 1
        flash[:list] = "you are not uploading .zip file"
        redirect_to "/list?r="+params[:r] and return
      end
      `sudo chmod -R 777 #{@@directory}/#{dirfolder}`
      File.open("#{@@directory}/#{dirfolder}/"+uploaded_io.original_filename, 'wb') do |file|
        file.write(uploaded_io.read)
        file.close
      end
      zipfile = "#{@@directory}/#{dirfolder}/"+uploaded_io.original_filename
      unzipfile = "#{@@directory}/#{dirfolder}/"
      unzip_file(zipfile, unzipfile)
      `rm #{zipfile}`
      Dir.chdir(@@directory+"/"+apps_name){
        `git add .`
        `git commit -m 'upload folder #{uploaded_io.original_filename}'`
        `git push lsorigin2 master -f`
        if apps_name == 'ls1'
            `git remote add lsdev ubuntu@letspan.com:/home/ubuntu/git-www/devletspan`
            `git push lsdev master -f`
        end
      }
      redirect_to "/list?r="+params[:r] and return
  end
  
  def download
    r = params[:r]
    apps_name = r.split("-__-")[1]
    dirfolder = r.gsub(/\-\_\_\-/, "\/")
    Dir.chdir(@@directory+"/"+dirfolder){
        `rm /var/www/ls/upload/img/#{apps_name}.zip`
        IO.popen("zip /var/www/ls/upload/img/#{apps_name} * ")
    }
    redirect_to "http://dev.img.letspan.com/#{apps_name}.zip" and return
  end

  def rsync 
    r = params[:r]
    back = r.split("-__-")
    apps_name = back[1]
    from = params[:back]
    back.pop
    r = back.join("-__-")
    path = r.gsub(/\-\_\_\-/, "\/")
    `rsync -zvr --delete #{@@directory}/#{apps_name} /var/www/ls/prod > /var/www/ls/note/rsync.txt`
    `sudo chmod -R 777 /var/www/ls/prod/#{apps_name}`
    if apps_name == 'ls1'
        Dir.chdir(@@directory+"/"+apps_name){
            `git remote rm lsprod`
            `git add .`
            `git commit -m 'a'`
            `git remote add lsprod ubuntu@letspan.com:/home/ubuntu/git-www/letspan`
            `git push lsprod master -f`
        }
    end
    flash[:note] = '1'
    redirect_to "#{from}"
  end

end














