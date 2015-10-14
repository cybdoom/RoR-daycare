class Admin::CustomersController < ApplicationController

  def import_new
    if CustomerType.count < 1
      flash[:notice] = 'You need to add customer type first!'
      redirect_to add_customer_types_admin_customers_path
    else
      @customer = Daycare.new
    end
  end

  def import
    if params[:customer_type_id].present?
      Daycare.import(params[:file], params[:customer_type_id])
      flash[:success] = "Success: customers were loaded"
      redirect_to admin_dashboard_path
    else
      flash[:error] = 'Please select customer type first!'
      render :import_new
    end
  end

  def add_customer_types
    if request.post?
      if params[:name].present?
        params[:name].each do |name|
          CustomerType.create(name: name)
        end
        flash[:notice] = 'CustomerType created successfully'
      else
        flash[:error] = 'Please select customer type'
      end
      redirect_to '/admin/customers/import_new'
    end
  end
  
end
