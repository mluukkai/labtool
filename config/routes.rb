Labtool::Application.routes.draw do
  resources :peer_reviews
  resources :week_feedbacks
  resources :registrations
  resources :checklists
  resources :checks
  resources :checktypes
  resources :courses
  resources :peer_reviews
  resources :users do
    post 'toggle_hidden', :on => :member
  end

  get  'checklists/:id/user/:registration_id' => 'passed_checks#show'
  post 'checklists/:id/user/' => 'passed_checks#update'
  get  'checklists/:id/values/' => 'checklists#edit_values', :as => "edit_checklist_values"
  get  'checklists/ajax/new_topic_form' => 'checklists#new_topic'
  get  'checklists/ajax/new_check_form' => 'checklists#new_check'
  get  'checklists/ajax/import_check_form' => 'checklists#import_check'
  post 'checklists/:id/values/' => 'checklists#update_values'

  post 'checktypes/:id/reorder/' => 'checks#reorder'

  match 'register' => 'registrations#new'

  get "logout" => "sessions#destroy", :as => "logout"
  get "login" => "sessions#new", :as => "login"

  resources :sessions

  match 'courses/:id/activity' => 'courses#activity', :via => :post

  match 'week_feedbacks/note' => 'week_feedbacks#create_note', :via => :post

  get  'mypage' => 'mypage#index'
  post 'mypage' => 'mypage#redirect'
  get  'mypage/:student_number' => 'mypage#show'
  post 'mypage/:student_number' => 'mypage#edit'
  match 'mypage/:student_number' => 'mypage#update',  :via => :put

  match 'foobar' => 'mypage#foobar'
  match 'toggle_review' => 'peer_reviews#toggle_review'
  match 'remove_review' => 'peer_reviews#remove_review'
  match 'complete_review' => 'peer_reviews#complete_review'
  match 'reset_reviews' => 'peer_reviews#reset'
  match 'generate_reviews' => 'peer_reviews#generate'
  match 'toggle_review_participation' => 'peer_reviews#toggle_participation'
  post '/peer_review' => 'peer_reviews#create'

  match 'toggle_registration' => 'registrations#toggle_activity'

  root :to => 'mypage#index'
end
