class SessionsController < ApplicationController

	def create
		begin  
			user = User.find_by(email: login_params[:email])
			if user && user.authenticate(login_params[:password])
				session[:user_id] = user.id
				flash[:success] = "Welcome #{user.name}!"

				redirect_to products_path
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
			redirect_to '/' 
		rescue Exception => e
			puts "#{e}"
			flash[:error] = 'Sorry! Sometime went wrong.Please try again'
			redirect_to dashboard_path;
			# puts e.backtrace.inspect  
		end  

	end 


	private
	def login_params
		params.require(:login).permit(:email, :password)
	end
end
