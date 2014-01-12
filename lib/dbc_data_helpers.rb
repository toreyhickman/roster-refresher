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
    start_this_year(start_date) || graduated_within_90_days(start_date)
  end

  def start_this_year(start_date)
    Date.parse(start_date).year == Time.now.year
  end

  def graduated_within_90_days(start_date)
    grad_date = Date.parse(start_date) + 60
    Date.today - 90 <= grad_date
  end

  def melt_or_hold(cohort_name)
    cohort_name =~ /melt|hold/i
  end
end
