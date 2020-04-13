class OrdersController < ApplicationController
	before_action :is_signed_in?

	def is_signed_in?
		if session[:user_id] 
			puts "is_signed_in"
		else 
			redirect_to '/'
		end
	end
		def index
		@categories = Category.all
		@current_user = current_user;
		@current_category = params[:current_category]
	end

	def new
		@current_user = current_user;
		@selectedproducts = [];
		params[:selectedproducts].each { |id|
			@selectedproducts << Product.find(id);  
		}
	end


	def purchase
		puts "???????????????????????#{params}"
	end

end
