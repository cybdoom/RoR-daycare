class Admin::TodosController < ApplicationController
  before_action :authenticate_admin!
  before_action :ensure_superadmin
  
  # before_action :set_daycare
  # before_action :parse_date, only: [:create, :update]

  # def index
    
  # end

  def new
    # @todo = @daycare.todos.new
    # @todo.key_tasks.build
  end

  # def create
  #   @todo = @daycare.todos.new(todo_params)
  #   if @todo.save
  #     redirect_to share_todo_todo_path(@todo)
  #   else
  #     render :new
  #   end
  # end

  # def edit
    
  # end

  # def update
    
  # end

  # def show
    
  # end

  # def destroy
    
  # end

  # def share_todo
  #   @todo = Todo.find(params[:id])
  # end

  # def todo_departments
  #   @todo = Todo.find(params[:id])
  #   if request.post?
  #     params[:department_ids].each do |department_id|
  #       department_todo = @todo.department_todos.new(department_id: department_id)
  #       department_todo.save
  #     end
  #     flash[:notice] = 'Todo has been shared with these departments successfully!'
  #     redirect_to current_daycare
  #   end
  # end

  # private

  #   def set_daycare
  #     @daycare = current_daycare
  #   end

  #   def todo_params
  #     params.require(:todo).permit!
  #   end

  #   def parse_date
  #     params[:todo][:schedule_date] = Chronic.parse(params[:todo][:schedule_date])
  #     params[:todo][:due_date] = Chronic.parse(params[:todo][:due_date])
  #   end

end
