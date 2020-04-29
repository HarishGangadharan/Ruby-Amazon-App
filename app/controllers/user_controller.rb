class UserController < ApplicationController

 

  # before_action :is_signed_in?, only: [:create, :accountdetails, :forgotpassword, :resetpassword, :sendmail, :index]

  # def is_signed_in?
	#    if session[:user_id] 
  #       redirect_to '/'
	# else 
  #   # redirect_to '/'
	# end
	
  #   end

    def create
        begin  
            user = User.new(user_params)
            puts ">user_paramsuser_params, #{user_params}"
            user.save!
            session[:user_id] = user.id
            flash[:success] = 'Successfully registered!'
            redirect_to '/'          
          rescue Exception => e
            puts ">>>>>>>>>>>>>>>>>>>>>>>>>>>>#{e}"
            flash[:error] = 'Sorry! Failed to register.Please try again'
            redirect_to '/'
            # puts e.backtrace.inspect  
          end        

    end

  def profile
    begin
      @user = current_user;
      @current_user = current_user; 
    rescue Exception => e
      puts "#{e}"
      flash[:error] = 'Sorry! Sometime went wrong.Please try again'
      redirect_to products_path
      # puts e.backtrace.inspect  
    end     
  end
  
 

  def saveprofile

   begin
    user = current_user;
    puts ">>>>>>>>>>>>>>#{user_params}"
    user.firstname = user_params[:firstname]
    user.lastname = user_params[:lastname]
    user.mobile = user_params[:mobile]
    user.addressline = user_params[:addressline]
    user.street = user_params[:street]
    user.city = user_params[:city]
    user.pincode = user_params[:pincode]

    user.image = nil
    user.image = user_params[:image]

    user.save!
    flash[:success] = 'Successfully Updated'

    redirect_to products_path; 
   rescue Exception => e
    puts "#{e}"
    flash[:error] = 'Sorry! Sometime went wrong.Please try again'
    redirect_to products_path
    # puts e.backtrace.inspect  
  end   


  end


  def forgotpassword
  end

  def changepassword

  begin
    vars = request.query_parameters
    @token = vars['token']

    user = User.find_by(pwdresettoken: params[:token])
    minutes = (Time.now - user.updated_at) / 1.minutes
    if (minutes < 3)
   puts "1111111111111111"

    else
      redirect_to '/'
      flash[:error] = 'Link has been expired'
      user.pwdresettoken = nil
      user.save!
    end
  rescue Exception => e
    puts "#{e}"
    flash[:error] = 'Link has been expired'
    redirect_to orders_path
    # puts e.backtrace.inspect  
  end  



  end

  def resetpassword

    begin
      user = User.find_by(pwdresettoken: params[:token])
      minutes = (Time.now - user.updated_at) / 1.minutes
      if (minutes < 3)
       user.password = params[:password]
       user.password_confirmation = params[:password_confirmation]
       user.pwdresettoken = nil
       user.save!
       flash[:success] = 'Password Updated'

      else
        
      end
    rescue Exception => e
      puts "#{e}"
      flash[:error] = 'Link has been expired'
      # puts e.backtrace.inspect  
    end  
    redirect_to '/'

  end

  def sendmail

  begin
  
    token = SecureRandom.hex(10)
    user = User.find_by(email: params[:email])
    if user
      user.pwdresettoken = token
      user.save!
      UserMailer.reset_password(params[:email], token).deliver;
    end
  rescue Exception => e
    puts "#{e}"
    flash[:error] = 'Sorry! Sometime went wrong.Please try again'
    # puts e.backtrace.inspect  
  end   
   redirect_to '/'
  end


    private
      def user_params
        params.require(:user).permit(:name, :email, :password,
           :password_confirmation, :is_admin, :firstname, :lastname ,
            :mobile , :addressline,:street,:city,:pincode, :routekey, :image)
      end
end
