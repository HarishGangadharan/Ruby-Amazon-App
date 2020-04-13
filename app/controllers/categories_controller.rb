class CategoriesController < ApplicationController

	before_action :set_category, only: [:show, :edit, :update, :destroy]
	before_action :is_signed_in?

	def is_signed_in?
		if session[:user_id] 
			puts "is_signed_in"
		else 
			redirect_to '/'
		end
	end

	# GET /categories
	# GET /categories.json
	def index
		@categories = Category.all
		@current_user = current_user;
		@current_category = params[:current_category]
	end

	# GET /categories/1
	# GET /categories/1.json
	def show
	end

	# GET /categories/new
	def new
		@category = Category.new
		@current_user = current_user;
	end

	# GET /categories/1/edit
	def edit
		@category = Category.find(params[:id])
		@current_user = current_user;
	end

	def viewproducts
		@current_category = params[:current_category]
		session[:current_category] = @current_category
		redirect_to viewproducts_path(@current_category_id, :current_category_id => params[:current_category])
	end

	def view
		vars = request.query_parameters
		@current_user = current_user;
		@current_category = vars['current_category_id']
		@current_category_name  = Category.find( vars['current_category_id']);
		@products  = Product.all(:conditions => { :category_id => vars['current_category_id'] })
			end

	def create
		@category = Category.new(category_params)
		if @category.save
			redirect_to categories_url
		else
			render :new
		end
	end

	# PATCH/PUT /categories/1
	# PATCH/PUT /categories/1.json
	def update
		if @category.update(category_params)
			redirect_to categories_url
		else
			format.html { render action: 'edit' }
			format.json { render json: @category.errors, status: :unprocessable_entity }
		end
	end

	# DELETE /categories/1
	# DELETE /categories/1.json
	def destroy
		@category.destroy
		respond_to do |format|
			format.html { redirect_to categories_url }
			format.json { head :no_content }
		end
	end

	private
	# Use callbacks to share common setup or constraints between actions.
	def set_category
		@category = Category.find(params[:id])
	end

	# Never trust parameters from the scary internet, only allow the white list through.
	def category_params
		params.require(:category).permit(:name, :desccriptioin)
	end
end
