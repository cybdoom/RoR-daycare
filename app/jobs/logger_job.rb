class LoggerJob 
  include SuckerPunch::Job

  def perform(data)
    puts data
  end

  def set_occurence
    todos = Todo.includes(:occurrences).where("todos.frequency != ? AND occurrences.schedule_date <= ? AND occurrences.due_date > ?", "One Time Event", DateTime.now, DateTime.now).references(:occurrences)
    todos.each do |todo|

      current_occurrence = todo.current_occurrence
      unless todo.next_occurrences.present?
        nxt_o = Occurrence.create(todo_id: todo.id, schedule_date: current_occurrence.next_schedule_date, due_date: current_occurrence.next_due_date, status: :draft)
        if nxt_o.present? && nxt_o.valid?
          nxt_o.save_user_occurrences(user_ids=todo.users.pluck(:id)) unless todo.is_circulatable?
          puts("Next Occurrence Created Successfully")
        else
          puts("Failed to create Next Occurrence")
          puts(nxt_o.errors.full_messages.join(", "))
        end
      end
    end
  end

  def later(sec, data)
    after(sec) { set_occurence }
  end

end
