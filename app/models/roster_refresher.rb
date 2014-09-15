class RosterRefresher
  MAX_ROWS = 35
  MAX_COLUMNS = 10

  def self.spreadsheet
    GoogleDrive.login(ENV['MAIL'], ENV['AUTH']).spreadsheet_by_key(ENV['DOC_KEY'])
  end

  def update_spreadsheet(cohorts)
    spreadsheet = RosterRefresher.spreadsheet

    returns_from_worksheet_updates = cohorts.each_with_object(Array.new) do |cohort, returns|
                                       returns << update_or_create_worksheet(spreadsheet, cohort)
                                     end

    returns_from_worksheet_updates.all?
  end

  def update_or_create_worksheet(spreadsheet, cohort)
    ws = spreadsheet.worksheet_by_title(cohort.name) || spreadsheet.add_worksheet(cohort.name, MAX_ROWS, MAX_COLUMNS)
    clear(ws)

    write_student_data(ws, cohort.just_students)
    write_student_count(ws)
    write_updated_on(ws)

    ws.save()
  end

  def clear(ws)
    row_count = ws.num_rows()
    col_count = ws.num_cols()

      (1..row_count).each do |row|
        (1..col_count).each do |col|
          ws[row, col] = ""
        end
      end

    ws.save()
  end

  def write_student_data(ws, students)
    students.sort_by(&:name).each.with_index(1) do |student, row|
      ws[row, 1] = student.name
      ws[row, 2] = student.email
      ws[row, 3] = student.twitter_handle
    end
  end

  def write_student_count(ws)
    count = ws.num_rows()
    row = count + 1

    ws[row, 1] = count
  end

  def write_updated_on(ws)
    row = ws.num_rows() +  1

    ws[row, 1] = DateTime.now.strftime("Roster updated: %b %d %H:%M")
  end
end
