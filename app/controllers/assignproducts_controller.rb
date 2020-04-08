class AssignproductsController < ApplicationController

	def index
		@products = Product.all
		@current_user = current_user;
		@current_category = params[:current_category]

	end
		def show
		#   @product = Product.find(params[:id])
	end
		def new
		@product = Product.new
		@current_user = current_user;

	end
		def action
		params[:checked].each { |item|
			if item[1] == "1" 
				id = item[0];

				product = Product.find(id);  
				product[:category_id] = current_category;
				product.save

			else 
				puts ""              

			end
		}
		redirect_to categories_path
	end
	
end



