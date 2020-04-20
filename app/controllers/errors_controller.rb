class ErrorsController < ApplicationController

    def show
        @current_user = current_user
        render :status => 404
      end
end
