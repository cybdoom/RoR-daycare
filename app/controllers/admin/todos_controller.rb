class Admin::TodosController < ApplicationController
  before_action :authenticate_admin!
  before_action :ensure_superadmin
  before_action :parse_date, only: [:create, :update]

  def index
    @todos = Todo.includes(:departments, :users).where(daycare_id: params[:daycare_ids]).where('users.type in (?)', params[:user_type]).references(:todo)
    @todos = Todo.all
    
  end

  def new
    @todo = Todo.new
    @todo.key_tasks.build
    @todo.build_icon
  end

  def create
    @todo = Todo.new(todo_params)
    if params[:todo_assignee] == 'departments'
      @departments = Department.where(daycare_id: params[:daycare_ids])
      @departments.each do |department|
        @todo.department_todos.build(department_id: department.id)
      end
    else
      params[:user_type].each do |user_type|
        if user_type != 'Partner'
          users = user_type.constantize.where(daycare_id: params[:daycare_ids])
          users.each do |user|
            @todo.user_todos.build(user_id: user.id)
          end
        end
      end
    end
    params[:daycare_ids].each do |daycare_id|
      @todo.daycare_todos.build(daycare_id: daycare_id)
    end
    if @todo.save
      flash[:notice] = 'Todo Successfully created!'
      redirect_to admin_dashboard_path
    else
      render :new
    end
  end

  def todo_assignee
    if params[:todo_assignee] == 'users'
      @show_user_types = true
    else
      @show_user_types = false
    end
  end

  def edit  
    @todo = Todo.find(params[:id])  
    @todo.build_icon if @todo.icon.blank?
  end

  def update
    @todo = Todo.find(params[:id])  
    @todo.update_attributes(todo_params)
    flash[:notice] = 'Todo Successfully updated!'
    redirect_to admin_dashboard_path
  end

  def destroy
    @todo = Todo.find(params[:id])
    @todo.destroy
    flash[:notice] = 'Todo Successfully deleted!'
    redirect_to admin_dashboard_path
  end

  def search
  end

  private

    def todo_params
      params.require(:todo).permit!
    end

    def parse_date
      params[:todo][:schedule_date] = Chronic.parse(params[:todo][:schedule_date])
      params[:todo][:due_date] = Chronic.parse(params[:todo][:due_date])
    end

end
