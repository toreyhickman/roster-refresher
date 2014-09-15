require 'date'

module DBCDataHelpers
  def recent_chicago_cohorts
    cohorts = get_cohorts.select do |cohort|
      cohort.location == "Chicago" &&
      !melt_or_hold(cohort.name) &&
      recent(cohort.start_date)
    end

    cohorts.sort_by(&:start_date)
  end

  private
  def get_cohorts
    DBC::Cohort.all
  end

  def recent(start_date)
    start_within_30_days(start_date) || graduated_within_45_days(start_date)
  end

  def start_this_year(start_date)
    Date.parse(start_date).year == Time.now.year
  end

  def start_within_30_days(start_date)
    ruby_start_date = Date.parse(start_date)
    max_start_date = Date.today + 30
    today = Date.today

    ruby_start_date >= today && ruby_start_date <= max_start_date
  end

  def graduated_within_45_days(start_date)
    grad_date = Date.parse(start_date) + 45
    Date.today - 45 <= grad_date
  end

  def melt_or_hold(cohort_name)
    cohort_name =~ /melt|hold/i
  end
end
