require 'date'

# Patch classes form DBC gem
module DBC

  class Cohort
    NUMBER_OF_DAYS_IN_SESSION = 60

    def self.recent_cohorts
      cohorts = self.all

      recent_cohorts = cohorts.select { |c| c.recent? && !c.melt_or_hold? && c.name_has_year? }
      recent_cohorts.sort_by(&:start_date)
    end

    def self.recent_cohorts_by_location(target_location)
      recent_cohorts.select { |c| c.location == target_location}
    end

    def melt_or_hold?
      name =~ /melt|hold/i
    end

    def name_has_year?
      name =~ /\d{4}/
    end

    def recent?
      start_within_x_days?(30) || graduated_within_x_days?(45)
    end

    def start_within_x_days?(num_of_days)
      ruby_start_date = Date.parse(start_date)
      max_start_date = Date.today + num_of_days
      today = Date.today

      ruby_start_date >= today && ruby_start_date <= max_start_date
    end

    def graduated_within_x_days?(num_of_days)
      grad_date = Date.parse(start_date) + NUMBER_OF_DAYS_IN_SESSION
      Date.today - 45 <= grad_date
    end

    def just_students
      self.students.select { |student| student.roles == ["student"] }
    end
  end

  class User
    def twitter_url
      profile[:twitter] || String.new
    end

    def twitter_handle
      twitter_url.sub(/(^\S*\/)?@?(?<handle>[\w]+)/, '@\k<handle>')
    end

    def github_url
      profile[:github] || String.new
    end

    def github_handle
      github_url.sub(/(^\S*\/)?@?(?<handle>[\w]+)/, '\k<handle>')
    end
  end
end
