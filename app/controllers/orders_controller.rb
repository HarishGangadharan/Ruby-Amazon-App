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
			if current_user.is_admin
				@orders = Order.all
			else
				@orders = Order.where(user_id: current_user.id)

			end
		@current_user = current_user;

	end

	def new
		@order = Order.new
		@current_user = current_user;
		@selectedproducts = [];
		@sp = '';
		params[:selectedproducts].each { |id|
			@selectedproducts << Product.find(id);  
			@sp = id  + ',' + @sp
		}
		session[:selectedproducts] = @sp;
	end


	def purchase
		begin
			@order = Order.create(order_params)
		rescue Exception => e
			puts ">>>>}>>>>>>>>>>>>>>>>>>>>>>>>., #{e}"
		end
		redirect_to orders_path
	end

    private
      def order_params
        params.require(:order).permit(:name, :description, :price, :user_id)
      end


end
