class TodosController < ApplicationController
  before_action :authenticate_manager!, except: [:accept_todo]
  before_action :set_daycare
  before_action :set_todo, only: [:edit, :update, :show, :destroy, :share_todo, :share_with_departments, :share_with_workers, :share_with_parents ]
  before_action :parse_date, only: [:create, :update]
  before_action :check_create_permission, only: [:new, :create, :delete]
  before_action :check_view_permission, only: [:show, :search]
  before_action :check_edit_permission, only: [:edit, :update]

  def index
  end

  def new
    @todo = @daycare.todos.new
    @todo.key_tasks.build
    @todo.build_icon
  end

  def create
    @todo = @daycare.todos.new(todo_params)
    if @todo.save!
      flash[:success] = 'Todo has been successfully created'
      redirect_to share_todo_todo_path(@todo)
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @todo.update(todo_params)
      flash[:success] = 'Todo has been successfully updated'
      redirect_to share_todo_todo_path(@todo)
    else
      render :edit
    end
  end

  def show
  end

  def search
    @todos = current_daycare.todos
  end

  def destroy
  end

  def share_todo
  end

  def share_with_departments
    if request.post?
      params[:department_ids].each do |department_id|
        department_todo = @todo.department_todos.new(department_id: department_id)
        department_todo.save
      end
      flash[:success] = 'Todo has been shared with these departments successfully!'
      redirect_to current_daycare
    end
  end

  def share_with_workers
    if request.post?
      @todo.save_user_todos( params[:worker_ids])
      flash[:success] = 'Todo has been shared with these workers successfully!'
      redirect_to current_daycare
    end
  end

  def share_with_parents
   if request.post?
      @todo.save_user_todos( params[:parent_ids])
      flash[:success] = 'Todo has been shared with these parents successfully!'
      redirect_to current_daycare
    end
  end

  def accept_todo
    if current_user
      @todo.update_attributes(status: "accepted", acceptor_id: current_user.id)
      flash[:success] = 'You have accepted the task successfully'
      redirect_to current_daycare
    end
  end

  private

    def set_daycare
      @daycare = current_daycare
    end

    def set_todo
      if action_name == "accept_todo" 
        @todo = Todo.find(params[:id])
      else
        @todo = current_daycare.todos.find(params[:id])
      end
    end

    def todo_params
      params.require(:todo).permit!
    end

    def parse_date
      params[:todo][:schedule_date] = Chronic.parse(params[:todo][:schedule_date])
      params[:todo][:due_date] = Chronic.parse(params[:todo][:due_date])
    end

    def check_create_permission
      unless current_user.can_create?('Todo')
        flash[:alert] = "You dont have permission to create todo"
        redirect_to @daycare
      end
    end

    def check_view_permission
      unless current_user.can_view?('Todo')
        flash[:alert] = "You dont have permission to view todo"
        redirect_to @daycare
      end
    end

    def check_edit_permission
      unless current_user.can_edit?('Todo')
        flash[:alert] = "You dont have permission to edit todo"
        redirect_to @daycare
      end
    end

    def authenticate_manager!
      unless current_user
        redirect_to login_daycares_path
      end
    end

end
