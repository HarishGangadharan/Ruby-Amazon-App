class Mailer
	include SuckerPunch::Job

	def perform(email, token)
  	  UserMailer.reset_password(email, token).deliver
	end
end