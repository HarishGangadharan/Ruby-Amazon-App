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
		if   product_params[:page] == 'dashboard'
			redirect_to dashboard_path
		else
			redirect_to products_path
		end
	end

	def filter
		@@filter_category_id = product_params[:filter_category_id];
		if   product_params[:page] == 'dashboard'
			redirect_to dashboard_path
		else
			redirect_to products_path
		end
	end

	def index
		if @@filter_category_id == nil
			@products = Product.all
		else
			@products  = Product.all(:conditions => { :category_id =>  @@filter_category_id})
		end
		@current_user = current_user;
		@categories = Category.all;
		@product = Product.new;
		@filter_category_id = @@filter_category_id.to_i;
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
		begin
			# @current_user = current_user;
			# redirect_to '/'  unless current_user
			@product = Product.create(product_params)
			# @product.created_by = current_user.email;
			# @product.modified_by = current_user.email;
			#  @product.save!
		rescue Exception => e
			puts ">>>>>>>>>>>>>>>>>>>>>>>>>>>>., #{e}"
		end
		redirect_to products_path
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

	def buy
		@selectedproducts = []
		params[:checked].each { |item|
			if item[1] == "1" 
				# id = item[0];
				@selectedproducts << item[0];
				# product = Product.find(id);  
				# product[:category_id] = @@current_category;
				# product.save
			else 
				puts ""              
			end
		}
		redirect_to new_order_path(selectedproducts: @selectedproducts)
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

	def dashboard
		@current_user = current_user;
		@categories = Category.all;
		@filter_category_id = @@filter_category_id.to_i;
		if @@filter_category_id == nil
			@products = Product.all
		else
			@products  = Product.all(:conditions => { :category_id =>  @@filter_category_id})
		end
	end

	private
	def product_params
		params.require(:product).permit(:name, :description, :price, :created_by ,
		:modified_by, :category_id, :filter_category_id, :page, :image)
	end
end
