namespace :todo_schedule do
  desc "Check due todos but status is not set because of missed jobs"
  task check_due_occurrences_n_user_occurrences: :environment do
    

    #set satatus of occurrences which are over due
    occs = Occurrence.where("due_date <= ? AND status != ?", DateTime.now, "ended")

    occs.each do |o|
      o.status = "ended"
      if o.save
        puts("Success")
      else
        puts("Failed")
      end
    end


    #set satatus of user_occurrences which are over due
    user_occs = UserOccurrence.includes(:occurrence).where("occurrences.due_date <= ? AND user_occurrences.todo_status not in (?)", DateTime.now, %w(completed not_completed not_completed_in_time)).references(:occurrences)
    user_occs.each do |uo|
      uo.todo_status = "not_completed"
      if uo.save
        puts("Success")
      else
        puts("Failed")
      end
    end
  end
end