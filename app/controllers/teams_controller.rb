class TeamsController < ApplicationController
  def index
    @teams = Team.all.order(:name)
  end

  def show
    @team = Team.find(params[:id])
    @matches = Match.where("home_team_id=? or away_team_id=?", @team.id, @team.id).limit(5).order(match_date_time: :desc)
    @form = []
    @matches.reverse.each do |m|
      if m.home_goals && m.away_goals
        if m.home_team_id == @team.id # Home game
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
  end
end
