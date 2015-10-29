class Api::V1::TodosController < Api::V1::BaseController
  # skip_before_action :authenticate_user_with_api_key
  before_action :check_create_params, only: [:new, :create]
  before_action :check_create_permission, only: [:new, :create]
  before_action :parse_date, only: [:create, :update]
  before_action :set_todo, only: [:edit, :update, :show, :destroy, :share_with_departments, :share_with_workers, :share_with_parents ]

  def index
  end


  def create
    binding.pry
    @todo = @current_daycare.todos.new(todo_params)
    # params[:todo][:key_tasks].each do |k_task|
    #   kt = @todo.key_tasks.build(name: k_task["name"])
    #   k_task["sub_tasks"].each do |sub_task|
    #     st = kt.sub_tasks.build(name: sub_task["name"])
    #   end
    # end

    # params[:todo][:key_tasks].each do |k, v|
    #   k_task = @todo.key_tasks.build(name: v["name"])
    #   v["sub_tasks"].each do |a, b|
    #     k_task = k_task.sub_tasks.build(name: b["name"])
    #   end
    # end

    if @todo.save
      render json: {result: 'success', message: 'Todo has been successfully created', todo_id: @todo.id} and return
    else
      error_msg = @todo.errors.full_messages.uniq.join(', ')
      render json: {result: 'failed', error: true, message: error_msg} and return
    end
  end

  # def edit
  # end

  # def update
  #   if @todo.update(todo_params)
  #     flash[:success] = 'Todo has been successfully updated'
  #     redirect_to share_todo_todo_path(@todo)
  #   else
  #     render :edit
  #   end
  # end

  # def show
  # end

  # def search
  #   @todos = current_daycare.todos
  # end

  # def destroy
  # end

  # def share_todo
  # end

  # def share_with_departments
  #   if request.post?
  #     params[:department_ids].each do |department_id|
  #       department_todo = @todo.department_todos.new(department_id: department_id)
  #       department_todo.save
  #     end
  #     msg = 'Todo has been shared with these departments successfully!'
  #     render json: {result: 'success', message: msg} and return
  #   end
  # end

  def share_with_workers
    if request.post?
      params[:worker_ids] ||= []
      params[:worker_ids] = params[:worker_ids].squish!.split(", ") if params[:worker_ids].class == String
      if params[:worker_ids]
        res, error_msg = @todo.save_user_todos( params[:worker_ids])
      else
        res, error_msg = false, "No Workers Selected"
      end

      if res
        msg = 'Todo has been shared with these workers successfully!'
        render json: {result: 'success', message: msg} and return
      else
        render json: {result: 'failed', error: true, message: error_msg} and return
      end
    end
  end

  def share_with_parents
    if request.post?
      params[:parent_ids] ||= []
      params[:parent_ids] = params[:parent_ids].squish!.split(", ") if params[:parent_ids].class == String
      if params[:parent_ids]
        res, error_msg = @todo.save_user_todos( params[:parent_ids])
      else
        res, error_msg = false, "No Parents Selected"
      end

      if res
        msg = 'Todo has been shared with these parents successfully!'
        render json: {result: 'success', message: msg} and return
      else
        render json: {result: 'failed', error: true, message: error_msg} and return
      end
    end
  end

  private

    def set_todo
      @todo = @current_daycare.todos.find(params[:id])
    end

    def todo_params
      # params.require(:todo).permit(:frequency, :recurring_rule, :schedule_date, :due_date, :is_delegatable, :is_circulatable, :title, icon_attributes: [:image])
      params.require(:todo).permit!
    end

    def check_create_permission
      unless current_user.can_create?('Todo')
        render json: {result: 'failed', error: true, message: "You don't have permission to create todo"} and return
      end
    end

    def parse_date
      # params[:todo][:schedule_date] = Chronic.parse(params[:todo][:schedule_date])
      params[:todo][:schedule_date] = Time.at(params[:todo][:schedule_date].to_i)
      params[:todo][:due_date] = Time.at(params[:todo][:due_date].to_i)
      # params[:todo][:due_date] = Chronic.parse(params[:todo][:due_date])
      # self.starts_at = Time.at(time)
    end

    def check_create_params
      error = []
      params[:todo] = {} unless params[:todo].present?
      error << "schedule_date required" unless params[:todo][:schedule_date]
      error << "due_date required" unless params[:todo][:due_date]

      if error.size > 0
        render json: {result: 'failed', error: true, message: error.join(", ")} and return
      end
    end


end