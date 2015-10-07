module LoginHelper
  
  def login_admin(admin)
    session[:admin_name] = admin.name
    session[:admin_id] = admin.id
  end

  def login_manager(manager)
    session[:manager_name] = manager.name
    session[:customer_id] = manager.customer_id
  end
  
  def logged_in?
    !session[:admin_name].nil?
  end
  
  def manager_logged_in?
    !session[:manager_name].nil?
  end

  def authorize
    if !logged_in?
      redirect_to login_url
    end
  end

  def manager_authorize
    if !manager_logged_in?
      redirect_to manager_login_url
    end
  end
  
  def log_out
    session.delete(:admin_name)
    session.delete(:admin_id)
  end

  def manager_log_out
    session.delete(:manager_name)
    session.delete(:manager_id)
  end
  
end
