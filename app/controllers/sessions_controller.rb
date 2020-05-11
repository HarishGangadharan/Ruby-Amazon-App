class SessionsController < ApplicationController

	def create
		begin  
		
			user = User.find_by(email: login_params[:email])
			if user && user.authenticate(login_params[:password])
				session[:user_id] = user.id
				flash[:success] = "Welcome #{user.name}!"

				if session[:purchasedproducts] != nil 


					@carts  = Cart.all(:conditions => { :customer_id => user.id})


					if @carts.length == 0 
					  @cart = Cart.create({customer_id: user.id})
					else
					  @cart = Cart.find_by customer_id: user.id
					end
					@cartItem = CartItems.find_by cart_id: @cart.id , 
					product_id:  session[:purchasedproducts]

					if @cartItem == nil

						CartItems.create({quantity: "1",
						cart_id: @cart.id, product_id: session[:purchasedproducts]})
	
					 else
						flash[:warning] = 'Product already in cart'
					 end




				
					redirect_to new_order_path
				else
					redirect_to products_path
				end

			else 
				flash[:error] = 'Invalid username or password'
				# render :new
				redirect_to '/'
			end
		rescue Exception => e
			puts "#{e}"
			flash[:error] = 'Sorry! Failed to login.Please try again'
			redirect_to '/'
			# puts e.backtrace.inspect  
		end  
	end

	def destroy    
		begin
			session[:user_id] = nil
			session[:sortKey] = nil     
			session[:filter_category_id] = nil
			redirect_to '/' 
		rescue Exception => e
			puts "#{e}"
			flash[:error] = 'Sorry! Sometime went wrong.Please try again'
			redirect_to '/';
			# puts e.backtrace.inspect  
		end  

	end 


	private
	def login_params
		params.require(:login).permit(:email, :password)
	end
end
