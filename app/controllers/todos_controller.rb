class TodosController < ApplicationController
  # before_action :authenticate_manager!, except: [:accept_todo]
  # before_action :ensure_manager, except: [:accept_todo]
  before_action :set_daycare
  before_action :set_todo, only: [:edit, :update, :show, :destroy, :share_todo, :accept_todo, :share_with_departments, :share_with_workers, :share_with_parents, :submit_todo]
  before_action :parse_date, only: [:create, :update]
  before_action :check_create_permission, only: [:new, :create]
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
    valid_todos = []
    @todo = Todo.new(todo_params)
    @todo.daycare_id = @daycare.id

    if params[:todo_assignee] == 'departments'
      @departments = Department.where(daycare_id: @daycare.id)
      @departments.each do |department|
        @todo.department_todos.build(department_id: department.id)
      end
    else
      params[:user_ids].each do |user_id|
        @todo.user_todos.build(user_id: user_id, status: (@todo.is_circulatable? ? "inactive" :  "active") )
      end
    end

    if @todo.valid?
      valid_todos << @todo 
    else
      @error = true
      flash[:error] = @todo.errors.full_messages.uniq.join(", ")
    end

    render :new  and return  if @error == true

    valid_todos.each do |t|
      t.save!
    end
    flash[:success] = 'Todo Successfully created!'
    redirect_to @daycare
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
      if params[:worker_ids]
        res, error = @todo.save_user_todos( params[:worker_ids]) 
         # o.save_user_occurrences(user_ids = self.users.pluck(:id)) if res
      else
        res, error = false, "No Workers Selected"
      end

      if res
        flash[:success] = 'Todo has been shared with these workers successfully!'
        redirect_to current_daycare
      else
        flash[:error] = error
        redirect_to :back 
      end
    end
  end

  def share_with_parents
    if request.post?
      if params[:parent_ids]
        res, error = @todo.save_user_todos( params[:parent_ids]) 
      else
        res, error = false, "No Parents Selected"
      end
      
      if res
        flash[:success] = 'Todo has been shared with these parents successfully!'
        redirect_to current_daycare
      else
        flash[:error] = error
        redirect_to :back 
      end
    end
  end

  def accept_todo
    if current_user
      if @todo.is_circulatable?
        @todo.user_todos.find_by(user_id: current_user.id, todo_id: @todo.id).update_attributes(status: :active)
        @todo.current_occurrence.save_user_occurrences([current_user.id])
        flash[:success] = 'You have accepted the task successfully'
      else
        flash[:error] = 'This is not a circulatable todo'
      end
      # @todo.update_attributes(status: "accepted", acceptor_id: current_user.id)
      redirect_to current_daycare
    end
  end

  def submit_todo
    # send(params[:act])
    if params[:comments].blank? && params[:act] == "mark_as_not_applicable"
      flash[:error] = "Please provide the comments first"
      redirect_to :back and return
    end
    @todo.current_occurrence.todo_comments.create(comment: params[:comments], user_id: current_user.id)  if params[:comments]
    @todo.current_occurrence.user_occurrence.send(params[:act])
    redirect_to :back
  end

  private
  
    def set_daycare
      @daycare = current_daycare
    end

    def set_todo
      if action_name == "" 
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

end
