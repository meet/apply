Apply::Application.routes.draw do
  
  get 'logout' => 'application#logout'
  
  get 'calls' => 'calls#index'
  get 'calls/:id' => 'calls#edit', :as => :call
  put 'calls/:id' => 'calls#update'
  
  get 'review/:model' => 'review#index', :as => :review
  get 'review/:model/:app_id' => 'review#show_or_edit', :as => :review_app
  post 'review/:model/:app_id' => 'review#create_or_update'
  get 'review/:model/:app_id/download/:column' => 'review#download', :as => :download
  
  root :to => 'apply#new'
  get ':model' => 'apply#new', :as => :apply
  post ':model' => 'apply#create'
  
end
