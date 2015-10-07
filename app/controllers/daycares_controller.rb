class DaycaresController < ApplicationController
  def new
    @daycare = Daycare.new
  end

  def create
    emails = User.all.map(&:email)
    @daycare = Daycare.new(daycare_params)
    unless emails.include?(@daycare.users.last.email)
      if @daycare.name.present? && @daycare.users.last && @daycare.users.last.email.present? && @daycare.save(validate: false)
        @daycare.roles.create(name: 'manager')
        flash[:notice] = "Daycare Successfully created."
        redirect_to @daycare
      else
        render :new
      end
    else
      flash[:notice] = "Email has already been taken"
      render :new
    end
  end

  def edit
    @daycare_manager = @daycare.daycare_manager
  end

  def update
    params[:daycare][:users_attributes] = {}
    params[:daycare][:users_attributes]["0"] = params[:daycare][:user] if params[:daycare][:user]
    params[:daycare].delete(:user)
    if @daycare.update_attributes(daycare_params)
      flash[:notice] = "Daycare Successfully updated."
      redirect_to @daycare
    else
      flash[:error] = "Daycare Not updated."
      render :edit
    end
  end

  private

    def daycare_params
      params.require(:daycare).permit!
    end
end
