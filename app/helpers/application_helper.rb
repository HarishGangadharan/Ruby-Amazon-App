module ApplicationHelper
    def flash_messages_for(object)
       render(:partial => 'shared/flash_messages', :locals => {:object => object})
    end
 end