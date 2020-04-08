class ProductsController < ApplicationController

	before_action :is_signed_in?
	@@filter_category_id = nil;

	def is_signed_in?
	if session[:user_id] 
		puts "is_signed_in"
	else 
		redirect_to '/'
	end
	end

	def reset
		@@filter_category_id = nil;
		redirect_to products_path
	end

    def filter
	@@filter_category_id = product_params[:filter_category_id];
	redirect_to products_path
    end

	def index
		if @@filter_category_id == nil
			@products = Product.all
		else
			@products  = Product.all(:conditions => { :category_id =>  @@filter_category_id})
		end

		@current_user = current_user;
		@categories = Category.all;
		@product = Product.new

	end

	def show
		@product = Product.find(params[:id])
		@current_user = current_user;

    end
	
	def new
		@product = Product.new
		@current_user = current_user;
		@categories = Category.all
	end

	def create
		@current_user = current_user;
		@product = Product.new(product_params)
		product_params[:created_by] = @current_user && @current_user.email;
		product_params[:modified_by] = @current_user &&  @current_user.email;
		if @product.save
			redirect_to products_path
		else
			render :new
		end
	end

	def edit
		@product = Product.find(params[:id])
		@current_user = current_user;
		@categories = Category.all;
		@categories.each { |category|
			if @product.category_id == category.id
				@category_name = category.name;
			else 
				puts ""              
			end
		}
	end

	def assign


	end

	def update
		@current_user = current_user;
		@product = Product.find(params[:id])
		if @product.update(product_params)
			redirect_to products_path
		else
			render :edit
		end
	end

	def destroy
		@product = Product.find(params[:id])
		@product.destroy
		redirect_to products_path
	end

	private
	def product_params
		params.require(:product).permit(:name, :description, :price, :created_by ,
			 :modified_by, :category_id, :filter_category_id)
	end
end
