class ProductsController < ApplicationController

	before_action :is_signed_in?
	def is_signed_in?
		if session[:user_id] 
			puts "is_signed_in"
		else 
			redirect_to '/'
		end
	end

	def index

		begin
	      if session[:filter_category_id] == nil
			session[:filter_category_id] = 'none'
		  end
	
		  if session[:filter_category_id] == 'none'
			@products = Product.all
		  else
			@products  = Product.all(:conditions => { :category_id =>  session[:filter_category_id]})
		  end

		  @current_user = current_user;
		  @categories = Category.all;
	      @product = Product.new;
		  @filter_category_id = session[:filter_category_id].to_i;
	    rescue Exception => e
		  puts "#{e}"
		  flash[:error] = 'Sorry! Something went wrong.Please try again'
		  redirect_to '/'
		  # puts e.backtrace.inspect  
	    end  
	end


	def create
		begin
		  @product = Product.create(product_params)
		  flash[:success] = 'Product Successfully Created!'
		rescue Exception => e
		  puts "e., #{e}"
		  flash[:error] = 'Sorry! Something went wrong.Please try again'
		  end
		  redirect_to products_path
		 end



		 def edit
			begin
			  @product = Product.find(params[:id])
			  @current_user = current_user;
			  @categories = Category.all;
			  @categories.each { |category|
				if @product.category_id == category.id
				  @category_name = category.name;
				 end
			  }
			rescue Exception => e
			  puts "e, #{e}"
			  flash[:error] = 'Sorry! Something went wrong.Please try again'
			  redirect_to products_path
		  end
		  
		  end

		  def update
			begin
			  @current_user = current_user;
			  @product = Product.find(params[:id])
			  flash[:success] = 'Product Successfully Updated!'
	  
			  if @product.update(product_params)
				  redirect_to products_path
			  else
				  render :edit
			  end
				
			rescue Exception => e
			  puts "e, #{e}"
			  flash[:error] = 'Sorry! Something went wrong.Please try again'
			  redirect_to products_path
	  
			end
	  
	  
		  end


		  def new
			begin
				@product = Product.new
				@current_user = current_user;
				@categories = Category.all	
			rescue Exception => e
				puts "e, #{e}"
				flash[:error] = 'Sorry! Something went wrong.Please try again'
				redirect_to products_path
			  end
		end
	

		def dashboard
			begin
				@current_user = current_user;
				@categories = Category.all;
				@filter_category_id = session[:filter_category_id].to_i;
				if session[:filter_category_id] == 'none'
					@products = Product.all
				else
					@products  = Product.all(:conditions => { :category_id => session[:filter_category_id] })
				end
			rescue Exception => e
				puts "e, #{e}"
				flash[:error] = 'Sorry! Something went wrong.Please try again'
				redirect_to products_path
			  end
		end


		def reset
			begin
				session[:filter_category_id] = 'none';
				if   product_params[:page] == 'dashboard'
					redirect_to dashboard_path
				else
					redirect_to products_path
				end
			rescue Exception => e
				puts "e, #{e}"
				flash[:error] = 'Sorry! Something went wrong.Please try again'
				redirect_to products_path
			  end
		end
	

		def filter
			begin
			  session[:filter_category_id] =  product_params[:filter_category_id];
			  if   product_params[:page] == 'dashboard'
				  redirect_to dashboard_path
			  else
				  redirect_to products_path
			  end
			rescue Exception => e
			  puts ">>>>}>>>>>>>>>>>>>>>>>>>>>>>>., #{e}"
			  flash[:error] = 'Sorry! Something went wrong.Please try again'
			  redirect_to products_path
			end
		  end



		  def show
			begin
			@product = Product.find(params[:id])
			@current_user = current_user;
		  rescue Exception => e
			puts ">>>>}>>>>>>>>>>>>>>>>>>>>>>>>., #{e}"
			flash[:error] = 'Sorry! Something went wrong.Please try again'
			redirect_to products_path
		  end

		end


	def buy
	  begin

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
		  
	  rescue Exception => e
		puts ">>>>}>>>>>>>>>>>>>>>>>>>>>>>>., #{e}"
		flash[:error] = 'Sorry! Something went wrong.Please try again'
		redirect_to products_path
	  end
		
	end



	def destroy
		puts ">>>>}>>>>>>>>>>1111111111111>>>>>>>>>>>>>>.,"

		begin
		@product = Product.find(params[:id])
		@product.destroy

		redirect_to products_path
		rescue Exception => e
			puts ">>>>}>>>>>>>>>>>>>>>>>>>>>>>>., #{e}"
			flash[:error] = 'Sorry! Something went wrong.Please try again'
			redirect_to products_path
		  end


	end



	private
	def product_params
		params.require(:product).permit(:name, :description, :price, :created_by ,
		:modified_by, :category_id, :filter_category_id, :page, :image)
	end
end
