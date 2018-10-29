class Team < ApplicationRecord
  belongs_to :league
  
  def matches
    @matches = Match.where("home_team_id=? or away_team_id=?", self.id, self.id).limit(5).order(match_date_time: :desc)
  end
  
  def past_matches
    @matches = Match.where("(home_team_id=? or away_team_id=?) and home_goals != ?", self.id, self.id, nil)
                    .limit(5).order(match_date_time: :desc)
  end
  
  def form(matches)
    @form = []
    matches.reverse.each do |m|
      if m.home_goals && m.away_goals
        if m.home_team_id == self.id # Home game
          if m.home_goals > m.away_goals
            @form.push "W"
          elsif m.home_goals == m.away_goals
            @form.push "D"
          else
            @form.push "L"
          end
        else                          # Away game
          if m.home_goals > m.away_goals
            @form.push "L"
          elsif m.home_goals == m.away_goals
            @form.push "D"
          else
            @form.push "W"
          end
        end
      end
    end
    @form
  end
end
