Rails.application.routes.draw do
devise_for :users

namespace :api do
	namespace :v1 do
		resources :books
	end 
end

namespace :api do
	namespace :v1 do 
		resources :authors
	end
end

end


