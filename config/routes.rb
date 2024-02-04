Rails.application.routes.draw do
  get 'workouts/index'
  get 'workouts/show'
  get 'workouts/create'
  get 'workouts/update'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
