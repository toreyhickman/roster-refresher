module GoogleDriveHelpers
  MAX_ROWS = 35
  MAX_COLUMNS = 10

  def update_spreadsheet(cohorts)
    spreadsheet = login_to_google.spreadsheet_by_key(ENV['DOC_KEY'])

    returns_from_saves = []

    cohorts.each do |cohort|
      returns_from_saves << update_or_create_worksheet(spreadsheet, cohort)
    end

    returns_from_saves.all?
  end

  def login_to_google
    GoogleDrive.login(ENV['MAIL'], ENV['AUTH'])
  end

  def update_or_create_worksheet(spreadsheet, cohort)
    ws = spreadsheet.worksheet_by_title(cohort.name) || spreadsheet.add_worksheet(cohort.name, MAX_ROWS, MAX_COLUMNS)
    clear(ws)

    write_student_data(ws, cohort.students)
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
    row = 1

    students.sort_by(&:name).each do |student|
      unless student.roles.include?('admin')
        ws[row, 1] = student.name
        ws[row, 2] = student.email
        ws[row, 3] = clean_twitter_handle(student.profile[:twitter])
        row += 1
      end
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

  def clean_twitter_handle(string)
    string.nil? ? String.new : string.sub(/(^\S*\/)?@?(?<handle>[\w]+)/, '@\k<handle>')
  end
end
