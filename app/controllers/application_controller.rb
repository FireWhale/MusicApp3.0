class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def js_redirect_to(path)
    render :js => "window.location.replace('#{path}');" and return
  end
  
  def pagination(item, type)
    
  end
  
  def filter(item, filterby, includeby)  
    
  end
end
