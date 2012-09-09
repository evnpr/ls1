require 'zip/zip'

class SiteController < ApplicationController

  @@directory = "/var/www/ls/upload"


  def index
  end

  
  def upload
    user_name = params[:username]
    apps_name = params[:name]
    database_name = params[:database_name]
    database_username = params[:database_username]
    database_pwd = params[:databasepwd]

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
            f.puts "members = evan@evan-Lenovo ls #{user_name} \n"
        end
        `ruby push.rb`
    }



    IO.popen("mkdir #{@@directory}/#{apps_name}")
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
    if(request.GET[:r].nil?) then
        @listfolder = Dir.glob("#{@@directory}/*/")
        @listfile = {}
        return
    end
    @root = 'pull'
    r = request.GET[:r]
    back = r.split("-__-")
    @apps_name = back[1]
    back.pop
    @back = back.join("-__-")
    path = r.gsub(/\-\_\_\-/, "\/")
    @name = path
    @listfolder = Dir.glob("#{@@directory}/#{@name}/*/").sort
    listfile = Dir.glob("#{@@directory}/#{@name}/*")
    listfolderfile = Dir.glob("#{@@directory}/#{@name}/*/").collect { |x| ; x.chop }
    @listfile = (listfile - listfolderfile).sort
    @current_path = r 
  end

  def listapps
    if(request.GET[:r].nil?) then
        @listfolder = Dir.glob("#{@@directory}/*/").sort
        @listfile = {}
    end
  end


  def showcontent
    r = request.GET[:r]
    @r = r 
    back = r.split("-__-")
    @apps_name = back[1]
    back.pop
    @back = back.join("-__-")
    path = r.gsub(/\-\_\_\-/, "\/")
    if File.exists?("#{@@directory}/#{path}")
        file = File.open("#{@@directory}/#{path}", "rb")
        @contents = file.read
    end
    @path = path
  end

  def savecontent
    r = params[:r]
    apps_name = r.split("-__-")[1]
    path = r.gsub(/\-\_\_\-/, "\/")
    `sudo chmod -R 777 #{@@directory}/#{path}`
    file = File.open("#{@@directory}/#{path}", "w")
    c = params[:content]
    file.write(c)
    file.close
    `sudo chmod -R 777 #{@@directory}/#{apps_name}`
    Dir.chdir(@@directory+"/"+apps_name){
        `git add .`
        `git commit -m 'save change on #{path}'`
        `git push lsorigin2 master -f`
    }
    redirect_to "/content/?r="+r and return
  end

  def github
    r = params[:r]
    username = 'evnpr'
    namerepos = 'lst'
    back = r.split("-__-")
    back.pop
    r = back.join("-__-")
    path = r.gsub(/\-\_\_\-/, "\/")
    if(request.GET[:g].nil?) then
        Dir.chdir(@@directory+"/#{path}"){
           # `git remote add lsorigin git@github.com:#{username}/#{namerepos}.git`
        }
    end
    Dir.chdir(@@directory+"/#{path}"){
        `git add .`
        `git commit -m 'push from ls'`
        `git push lsorigin master -f`
    }

    redirect_to "/content/?r="+params[:r] and return
  end


  def githubpull
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

    redirect_to "/content/?r="+params[:r] and return
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
    if request.post?
        user_name = params[:user_name]
        temprorary_res = '/var/www/ls/res/gitosis-admin/keydir/'+params[:user_name]+'.pub'
        unless File.exists?("#{temprorary_res}")
            `touch #{temprorary_res}`
            file = File.open(temprorary_res, "w")
            publickey = params[:key]
            file.write(publickey)
            file.close
        end
        Dir.chdir("/var/www/ls/res/gitosis-admin"){
            `ruby push.rb`
        }
        redirect_to "/list" and return
    end
  end


  def githubnew 
    if request.post?
        apps_name = params[:apps_name]
        yourname = params[:githubname]
        yourproject = params[:githubrepo]
        Dir.chdir(@@directory+"/"+apps_name){
           `git init`
           `git remote add lsorigin git@github.com:#{yourname}/#{yourproject}.git`
        }
        redirect_to "/list" and return
    end
    
  end

  def newfile
    r = params[:r]
    newfile = params[:newfile]
    dirfolder = r.gsub(/\-\_\_\-/, "\/")
    `touch #{@@directory}/#{dirfolder}/#{newfile}`
    redirect_to "/list?r="+params[:r] and return
  end

  def renamefile
    r = params[:r]
    oldfile = params[:oldfile]
    n = params[:newfile]
    dirfolder = r.gsub(/\-\_\_\-/, "\/")
    path = r.gsub(/\-\_\_\-/, "\/")+"/"
    newname = params[:newname]
    `mv #{@@directory}/#{dirfolder}/#{oldfile} #{@@directory}/#{dirfolder}/#{n}`
    redirect_to "/list?r="+params[:r] and return
  end



end

