class ProductsController < ApplicationController

	# before_action :is_signed_in?
	# def is_signed_in?
	# 	if session[:user_id] 
	# 		puts "is_signed_in"
	# 	else 
	# 		redirect_to '/'
	# 	end
	# end

	include ApplicationHelper


	def index


		begin
	      if session[:filter_category_id] == nil
			session[:filter_category_id] = 'none'
		  end
	
		  if session[:filter_category_id] == 'none'

			if session[:sortKey] == nil
				@products  = Product.all(:conditions => { :status =>  'active'})
			else
				@products  = Product.all(:conditions => { :status =>  session[:sortKey]})
			end
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
			puts "?>----------------#{product_params}"
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
	

		# def dashboard
		# 	begin
		# 		@current_user = current_user;
		# 		@categories = Category.all;
		# 		@filter_category_id = session[:filter_category_id].to_i;
		# 		if session[:filter_category_id] == 'none'
		# 			@products = Product.all
		# 		else
		# 			@products  = Product.all(:conditions => { :category_id => session[:filter_category_id] })
		# 		end
		# 	rescue Exception => e
		# 		puts "e, #{e}"
		# 		flash[:error] = 'Sorry! Something went wrong.Please try again'
		# 		redirect_to products_path
		# 	  end
		# end


		def reset
			begin
				session[:filter_category_id] = 'none';
				redirect_to products_path
			rescue Exception => e
				puts "e, #{e}"
				flash[:error] = 'Sorry! Something went wrong.Please try again'
				redirect_to products_path
			  end
		end
	

		def filter
			begin
			  session[:filter_category_id] =  product_params[:filter_category_id];
				redirect_to products_path
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

		begin
		@product = Product.find(params[:id])
		@product.update(status: "inactive")

		flash[:success] = 'Product Successfully Deleted!'

		respond_to do |format|
			format.html { redirect_to products_url }
			format.json { head :no_content }
		end

		rescue Exception => e
			puts ">>>>}>>>>>>>>>>>>>>>>>>>>>>>>., #{e}"
			flash[:error] = 'Sorry! Something went wrong.Please try again'
			redirect_to products_path
		  end


	end

	def view
	 begin
		vars = request.query_parameters
		@current_user = current_user;
		@product = Product.find_by(id:vars['product'])
	 rescue Exception => e
		puts ">>>>}>>>>>>>>>>>>>>>>>>>>>>>>., #{e}"
		flash[:error] = 'Sorry! Something went wrong.Please try again'
		redirect_to products_path
	  end
	end


	def restoreproduct

		begin

			vars = request.query_parameters
			 @product = Product.find_by(id:vars['product'])
			 @product.update(status: "active")
			 session[:sortKey] = nil;
			 redirect_to products_path


		rescue Exception => e
			puts ">>>>}>>>>>>>>>>>>>>>>>>>>>>>>., #{e}"
			flash[:error] = 'Sorry! Something went wrong.Please try again'
			redirect_to products_path
		  end
	end


	def addtocart
		begin
			vars = request.query_parameters
			@current_user = current_user;
			session[:purchasedproducts] =  vars['product']

			if current_user != nil
				@product = Product.find_by(id:session[:purchasedproducts])
				
				@carts  = Cart.all(:conditions => { :customer_id => current_user.id})

				 if @carts.length == 0 
				   @cart = Cart.create({customer_id: current_user.id})
				 else
                   @cart = Cart.find_by customer_id: current_user.id
				 end
				 
				 @cartItem = CartItems.find_by cart_id: @cart.id , product_id: vars['product']

				 if @cartItem == nil

					CartItems.create({quantity: "1",
					cart_id: @cart.id, product_id: vars['product']})

				 else
					flash[:warning] = 'Product already in cart'
				 end
				 
				redirect_to new_order_path
			else
				flash[:warning] = 'Please login to continue'
				redirect_to login_path
			end

			# @product = Product.find_by(id:vars['product'])
		 rescue Exception => e
			puts ">>>>}>>>>>>>>>>>>>>>>>>>>>>>>., #{e}"
			flash[:error] = 'Sorry! Something went wrong.Please try again'
			redirect_to products_path
		  end
	end

	def exportcsv
		begin
			require 'csv'
			file = "#{Rails.root}/public/products.csv"
			products = Product.all
			headers = ["id", "name", "price", "description", "quantity", "category_id", "status"]
			CSV.open(file, 'w', write_headers: true, headers: headers) do |writer|
			  products.each do |product|
				writer << [product.id, product.name, product.price, product.description,
				product.quantity, product.category_id, product.status]
			  end
			end
			flash[:success] = 'Product list csv has been generated under public folder'
			redirect_to products_path
		rescue Exception => e
			puts ">>>>}>>>>>>>>>>>>>>>>>>>>>>>>., #{e}"
			flash[:error] = 'Sorry! Something went wrong.Please try again'
			redirect_to products_path
    	end
	end

	def importcsv
		begin
			require 'csv'

			# csv_text = File.read(Rails.root.join('public', 'products.csv'))
			# csv = CSV.parse(csv_text, :headers => true, :encoding => 'ISO-8859-1')
			myfile = params['csvfile']
			CSV.foreach(myfile.path, headers: true) do |row|
				product = Product.find_by(id:row["id"])
				if product != nil
					product.attributes = row.to_hash
					product.save!
				else
				    Product.create!(row.to_hash)
				end
			end

		
				
			# end
				
			redirect_to products_path

		rescue Exception => e
			puts ">>>>}>>>>>>>>>>>>>>>>>>>>>>>>., #{e}"
			flash[:error] = 'Sorry! Something went wrong.Please try again'
			redirect_to products_path
    	end

	end

	def removeproduct
		begin

			vars = request.query_parameters
			@cartItem = CartItems.find_by product_id: vars['product']
			@cartItem.destroy
			 redirect_to new_order_path

		rescue Exception => e
			puts ">>>>}>>>>>>>>>>>>>>>>>>>>>>>>., #{e}"
			flash[:error] = 'Sorry! Something went wrong.Please try again'
			redirect_to products_path
		  end


	end


	def sort 
		begin
			if params[:sortKey] == "0"
				session[:sortKey] = 'active'
			else
				session[:sortKey] = 'inactive'
			end
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
		:modified_by, :category_id, :filter_category_id, :page, :image, :quantity, :status, :sortKey)
	end
end
