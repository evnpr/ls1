Letspan::Application.routes.draw do
  get "lsgit/index"

  get "server/index"

  get "user/index"
  get "user/login"
  post "user/login"
  get "user/register"
  post "user/register"
  get "user/logout"

  get "site/index"
  post "site/upload"
  match 'content' => 'site#showcontent'
  match 'ace-editor/vim' => 'site#showcontentvim'
  match 'list/' => 'site#list'
  match 'listapps/' => 'site#listapps'
  post 'site/savecontent'
  post 'site/savecontentgit'
  post "site/github"
  post "site/githubpull"
  post "site/bitbucket"
  post "site/bitbucketpull"
  match 'gitnew/:name' => 'site#gitnew'
  get "site/gitnew"
  post "site/gitnew"
  
  match "site/deleteapps/:apps_name" => "site#deleteapps"

  get "site/githubnew"
  post "site/githubnew"

  post "site/newfile"
  post "site/newfolder"
  post "site/renamefile"
  post "site/uploadfile"
  post "site/uploadfolder"
  match 'site/download/:r' => 'site#download'
  get "site/deletefile"


  match "rsync" => "site#rsync"
  match "syncdev" => "lsgit#syncdev"




  match 'gitdelete/:id' => 'site#gitdelete'
  
  post "site/collaborator"
  get "site/deletecol"
  
  ## SERVER ##
  
  post "server/submit"
  post "server/submitdb"


  post "lsgit/index"
  post "lsgit/deleteNotif"
  get "lsgit/index"


  get "lsgit/gitToDB"
  get "lsgit/goToVersion"
  
  match "updateApp/:apps" => 'lsgit#updateApp'
  

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'site#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end






