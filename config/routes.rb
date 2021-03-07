Rails.application.routes.draw do
  devise_for :users

  resources :questions do
    patch '/set_best_answer/:answer_id/', to: 'questions#set_best_answer', on: :member, as: 'set_best_answer'
    resources :answers, shallow: true, only: %i[create update destroy]
  end

  root to: 'questions#index'
end
