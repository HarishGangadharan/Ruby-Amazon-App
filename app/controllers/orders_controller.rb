class OrdersController < ApplicationController
	before_action :is_signed_in?

	def is_signed_in?
		if session[:user_id] 
			puts "is_signed_in"
		else 
			redirect_to '/'
		end
	end


	# def printorder
	# 			respond_to do |format|
	# 			format.html

	# 			format.pdf do
	# 				pdf = Prawn::Document.new
	# 				pdf.text "sdfadasd"
	# 				send_data pdf.render, filename: "order.pdf", 
	# 				type:'application/pdf', disposition:'inline'
	# 			end
	# 		end


	# 		# respond_to do |format|
	# 		# 	format.html
	# 		# 	format.json
	# 		# 	format.pdf {render template: 'orders/order', pdf: 'order'}
	# 		#   end
  
	# end
	def index
	 	begin
			if session[:customer_id] == nil
				session[:customer_id] = 'none'
			else
			end

			if current_user.is_admin
 				if session[:customer_id] == 'none'
					@orders = Order.all
				else
					@orders  = Order.all(:conditions => { :user_id =>  session[:customer_id]})
				end
			else
				@orders = Order.where(user_id: current_user.id)
			end
			@users = User.all
			@current_user = current_user;

		rescue Exception => e
			puts "#{e}"
			flash[:error] = 'Sorry! Something went wrong.Please try again'
			redirect_to orders_path
			# puts e.backtrace.inspect  
		end 
	end

	def new
		begin
			@order = Order.new
			@current_user = current_user;
			@selectedproducts = [];
			@sp = '';
			params[:selectedproducts].each { |id|
				@selectedproducts << Product.find(id);  
				@sp = id 
			}
			session[:selectedproducts] = @sp;
		rescue Exception => e
			puts "#{e}"
			flash[:error] = 'Sorry! Something went wrong.Please try again'
			redirect_to orders_path
			# puts e.backtrace.inspect  
		end 
	end


	def purchase
		begin
			@order = Order.create(order_params)
		rescue Exception => e
			puts "#{e}"
			flash[:error] = 'Sorry! Failed to login.Please try again'
			# puts e.backtrace.inspect  
		end  
		redirect_to orders_path
	end


	def filter
		begin
			
			session[:customer_id] =  order_params[:customer_id];
			redirect_to orders_path
		rescue Exception => e
			puts "#{e}"
			flash[:error] = 'Sorry! Something went wrong.Please try again'
			redirect_to orders_path
			# puts e.backtrace.inspect  
		end  
	 end


	 def reset

		begin
			session[:customer_id] = 'none';
		redirect_to orders_path	
		rescue Exception => e
			puts "#{e}"
			flash[:error] = 'Sorry! Something went wrong.Please try again'
			redirect_to orders_path
			# puts e.backtrace.inspect  
		end  
	
	end

	def vieworder

		begin
			vars = request.query_parameters
			@current_user = current_user;
			@orderDetails = Order.find_by(id:vars['order'])
			products = Product.all
			products.each { |product|
			if product.name == @orderDetails.name
				@product = product;
			 end
			}	
		rescue Exception => e
			puts "#{e}"
			flash[:error] = 'Sorry! Something went wrong.Please try again'
			redirect_to orders_path
			# puts e.backtrace.inspect  
		end  
	end

    private
      def order_params
		params.require(:order).permit(:name, :description, :price, :user_id,
		 :product_ids, :quantity, :customer_id)
      end


end
