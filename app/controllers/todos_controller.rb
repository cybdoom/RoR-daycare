class TodosController < ApplicationController
  before_action :authenticate_manager!
  before_action :set_daycare
  before_action :parse_date, only: [:create, :update]
  before_action :check_permission

  def index
    
  end

  def new
    @todo = @daycare.todos.new
    @todo.key_tasks.build
    @todo.build_icon
  end

  def create
    @todo = @daycare.todos.new(todo_params)
    if @todo.save
      redirect_to share_todo_todo_path(@todo)
    else
      render :new
    end
  end

  def edit
    
  end

  def update
    
  end

  def show
    
  end

  def destroy
    
  end

  def share_todo
    @todo = Todo.find(params[:id])
  end

  def todo_departments
    @todo = Todo.find(params[:id])
    if request.post?
      params[:department_ids].each do |department_id|
        department_todo = @todo.department_todos.new(department_id: department_id)
        department_todo.save
      end
      flash[:notice] = 'Todo has been shared with these departments successfully!'
      redirect_to current_daycare
    end
  end

  private

    def set_daycare
      @daycare = current_daycare
    end

    def todo_params
      params.require(:todo).permit!
    end

    def parse_date
      params[:todo][:schedule_date] = Chronic.parse(params[:todo][:schedule_date])
      params[:todo][:due_date] = Chronic.parse(params[:todo][:due_date])
    end

    def check_permission
      unless current_user.can_create?('Todo')
        redirect_to @daycare
      end
    end

    def authenticate_manager!
      unless current_user
        redirect_to login_daycares_path
      end
    end

end
