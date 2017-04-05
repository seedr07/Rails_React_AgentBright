class UxController < ApplicationController

  skip_before_action :authenticate_user!

  layout "ux"

  def index
    render
  end

end
