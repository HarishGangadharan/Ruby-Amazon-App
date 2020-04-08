class OrderController < ApplicationController
    before_action :is_signed_in?

	def is_signed_in?
	if session[:user_id] 
		puts "is_signed_in"
    	else 
		redirect_to '/'
	end
end


end
