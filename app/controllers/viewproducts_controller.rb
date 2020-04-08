class ViewproductsController < ApplicationController

    def index
        @current_user = current_user;
        @current_category = params[:current_category]
        @current_category_name = current_category_name
        puts "--------------ViewproductsController------------- #{current_category}"
        @products  = Product.all(:conditions => { :category_id => current_category })
    end

    def new
        @current_user = current_user;
        @current_category_name = current_category_name
      end
      
end
