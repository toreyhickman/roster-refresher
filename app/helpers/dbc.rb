helpers do
  def recent_chicago_cohorts
    DBC::Cohort.recent_cohorts_by_location("Chicago")
  end
end
