namespace :set_todo_next_occurrence do
  desc "Check Recurring Todos current occurrences completing after 3 days from now or before 3 days (tomorrow or day after tomorrow ) and set next schedule/occurrence if not already set"
  task next_occurrence: :environment do
    Occurrence.where("schedule_date >= ? AND due_date <= ", DateTime.now, DateTime.now + 2.days)
  end
end