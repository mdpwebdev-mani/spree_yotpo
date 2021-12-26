Spree::Core::Engine.routes.draw do
  namespace :admin do
    resources :yotpo_settings do
      post "setup_store" => "yotpo_settings#setup_store"
    end
  end
end
