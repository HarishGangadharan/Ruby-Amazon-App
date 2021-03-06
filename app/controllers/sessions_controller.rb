class SessionsController < ApplicationController

    def create

        

        begin  
            # emailVal = login_params[:email]; to_s
            # user = User.find_by email: emailVal.to_s
            # user = User.where(email: "sam@gmail.com")
            user = User.find_by(email: login_params[:email])
            if user && user.authenticate(login_params[:password])
                session[:user_id] = user.id

                
                redirect_to categories_path
                
            else 
                flash[:error] = 'Invalid username or password'
                # render :new

                redirect_to '/'
            end

        rescue Exception => e
            puts "#{e}"
            # puts e.backtrace.inspect  
          end  


          def destroy      
            session[:user_id] = nil     
            redirect_to '/' 
          end 

    end

    private
    
    def login_params
        params.require(:login).permit(:email, :password)
end
end
