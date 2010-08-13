class HomeController < AclController
  def initialize
    super
    @guest_perms += [ 'home/change_language']
  end

  def index
    @current_tab_id = :home
    if logged_in?
      @categories = Category.roots
    else
      @categories = Category.published_roots
    end
    
  end

  def change_language
    session[:language] = params[:id] unless params[:id].blank?
    redirect_to :back
  end
end
