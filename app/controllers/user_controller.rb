class UserController < ApplicationController

 

  before_action :is_signed_in?, only: [:create, :accountdetails, :forgotpassword, :resetpassword, :sendmail, :index]

  def is_signed_in?
	   if session[:user_id] 
        redirect_to dashboard_path
	else 
    # redirect_to '/'

	end
	
    end

    def create
        begin  
            user = User.new(user_params)
            puts ">user_paramsuser_params, #{user_params}"
            user.save!
            session[:user_id] = user.id
            redirect_to '/'          

        rescue Exception => e
            puts "#{e}"
            # puts e.backtrace.inspect  
          end           

    end

	def profile
    @user = current_user;
    @current_user = current_user;

  end
  
 

  def saveprofile
    user = current_user;
    user.firstname = user_params[:firstname]
    user.lastname = user_params[:lastname]
    user.mobile = user_params[:mobile]
    user.address = user_params[:address]
    user.image = nil
    user.image = user_params[:image]

    user.save!
    redirect_to products_path;
  end


  def forgotpassword
  end

  def changepassword
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

  end

  def resetpassword
    user = User.find_by(pwdresettoken: params[:token])
   minutes = (Time.now - user.updated_at) / 1.minutes
   if (minutes < 3)
    user.password = params[:password]
    user.password_confirmation = params[:password_confirmation]
    user.pwdresettoken = nil
    user.save!
   else
     
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
    puts ">>>>Exception>>>>>>>>, #{e}"
   end
   redirect_to '/'
  end


    private
      def user_params
        params.require(:user).permit(:name, :email, :password,
           :password_confirmation, :is_admin, :firstname, :lastname ,
            :mobile , :address, :routekey, :image)
      end
end
