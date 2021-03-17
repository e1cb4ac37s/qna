Rails.application.routes.draw do
  devise_for :users

  resources :questions do
    patch '/set_best_answer/:answer_id/', to: 'questions#set_best_answer', on: :member, as: 'set_best_answer'
    delete '/attachment/:file_id', to: 'questions#delete_attachment', on: :member, as: 'attachment'

    resources :answers, shallow: true, only: %i[create update destroy] do
      delete '/attachment/:file_id', to: 'answers#delete_attachment', on: :member, as: 'attachment'
    end
  end

  root to: 'questions#index'
end
