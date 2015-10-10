class TodosController < ApplicationController
  before_action :set_daycare
  before_action :parse_date, only: [:create, :update]

  def index
    
  end

  def new
    @todo = @daycare.todos.new
    @todo.key_tasks.build
    index = 0
    @incrementer = -> { index += 1}
  end

  def create
    @todo = @daycare.todos.new(todo_params)
    if @todo.save
      redirect_to @daycare
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

  private

    def set_daycare
      @daycare = Daycare.find(params[:daycare_id])
    end

    def todo_params
      params.require(:todo).permit!
    end

    def parse_date
      params[:todo][:schedule_date] = Chronic.parse(params[:todo][:schedule_date])
      params[:todo][:due_date] = Chronic.parse(params[:todo][:due_date])
    end

end
