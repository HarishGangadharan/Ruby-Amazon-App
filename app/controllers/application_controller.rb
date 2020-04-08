class ApplicationController < ActionController::Base
	# Prevent CSRF attacks by raising an exception.
	# For APIs, you may want to use :null_session instead.
	protect_from_forgery with: :exception

	add_flash_types :danger, :info, :warning, :success
	def current_user 
		id = session[:user_id] 
		user = User.find(id);
		return user;
	end

	def current_category
		id = session[:current_category] 
		puts "---------current_category----- application controller---#{id}"
		# category = Category.find(id);
		return id;
	end

	def current_category_name
		id = session[:current_category] 
		category = Category.find(id);
		return category;
	end

	def user_profile_confirmed
		puts "---------user_profile_confirmed----- application controller---"

	end
end
