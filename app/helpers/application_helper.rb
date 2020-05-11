require "active_support/number_helper"


module ApplicationHelper
    def flash_messages_for(object)
       render(:partial => 'shared/flash_messages', :locals => {:object => object})
    end

    def number_taso_currency(number)
#       NumberFormat formatter = new DecimalFormat("#,###");
# double myNumber = 1000000;
# String formattedNumber = formatter.format(myNumber);
     puts "........NumberFormat............, #{NumberFormat}"
   end


   def number_to_currency(number, options = {})
  a =  delegate_number_helper_method(:number_to_currency, number, options)
   puts "........NumberFormat............, #{a}"

 end

 def number_to_indian_currency(number)
   if number.present?
     string = number.to_s.split('.')
     number = string[0].gsub(/(\d+)(\d{3})$/){ p = $2;"#{$1.reverse.gsub(/(\d{2})/,'\1,').reverse},#{p}"}
     number = number.gsub(/^,/, '') + '.' + string[1] if string[1] # remove leading comma
     number = number[1..-1] if number[0] == 44
   end

   if number.split('')[0] == ',' 
       str = "GeeksforGeeks";  
             result = str.slice(1); 
       puts "---------number---str------#{ str}"
       puts "---------number---result------#{ result}"

    end
   return "₹ #{number}"

  end



 def delegate_number_helper_method(method, number, options)
   return unless number
   options = escape_unsafe_options(options.symbolize_keys)

   wrap_with_output_safety_handling(number, options.delete(:raise)) {
     ActiveSupport::NumberHelper.public_send(method, number, options)
   }
 end

 def escape_unsafe_options(options)
   options[:format]          = ERB::Util.html_escape(options[:format]) if options[:format]
   options[:negative_format] = ERB::Util.html_escape(options[:negative_format]) if options[:negative_format]
   options[:separator]       = ERB::Util.html_escape(options[:separator]) if options[:separator]
   options[:delimiter]       = ERB::Util.html_escape(options[:delimiter]) if options[:delimiter]
   options[:unit]            = ERB::Util.html_escape(options[:unit]) if options[:unit] && !options[:unit].html_safe?
   options[:units]           = escape_units(options[:units]) if options[:units] && Hash === options[:units]
   options
 end

 def escape_units(units)
   Hash[units.map do |k, v|
     [k, ERB::Util.html_escape(v)]
   end]
 end

 def wrap_with_output_safety_handling(number, raise_on_invalid, &block)
   valid_float = valid_float?(number)
   raise InvalidNumberError, number if raise_on_invalid && !valid_float

   formatted_number = yield

   if valid_float || number.html_safe?
     formatted_number.html_safe
   else
     formatted_number
   end
 end

 def valid_float?(number)
   !parse_float(number, false).nil?
 end

 def parse_float(number, raise_error)
   Float(number)
 rescue ArgumentError, TypeError
   raise InvalidNumberError, number if raise_error
 end

end