namespace :set_todo_next_occurrence do
  desc "Check Recurring Todos current occurrences completing after 3 days from now or before 3 days (tomorrow or day after tomorrow ) and set next schedule/occurrence if not already set"
  task next_occurrence: :environment do
    # current_time = DateTime.now
    # occs = Occurrence.joins(:todo).where("todos.frequency != ? AND occurrences.schedule_date <= ? AND occurrences.due_date >= ? AND occurrences.due_date <= ?", "One Time Event", current_time, current_time, (current_time + 2.days + 23.hours + 59.minutes + 59.seconds))
    # occs.each do |o|
    #   puts("ooo")
    #   unless o.todo.next_occurrence.present?
    #     nxt_o = Occurrence.create(todo_id: o.todo.id, schedule_date: o.next_schedule_date, due_date: o.next_due_date, status: :draft)
    #     if nxt_o.present? && nxt_o.valid?
    #       puts("Next Occurrence Created Successfully")
    #     else
    #       puts("Failed to create Next Occurrence")
    #       puts(nxt_o.errors.full_messages.join(", "))
    #     end
    #   end
    # end

    #todos with current_occurrence
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
end