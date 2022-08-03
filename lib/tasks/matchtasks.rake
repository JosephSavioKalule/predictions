require 'uri'
require 'net/http'
require 'openssl'


def get_rails_league_id(api_id)
  #  42 - Premier League
  #  43 - La Liga
  #  44 - Ligue 1
  #  45 - Serie A
  ids_hash = {
    "39" => "42",
    "140" => "43",
    "61" => "44",
    "135" => "45"
  }
  return ids_hash[api_id.to_s]
end

def get_rails_team_id(api_id)
  ids_hash = {
    # Begin Premier League
    "33" => "272",
    "34" => "273",
    "35" => "264",
    "36" => "274",
    "39" => "279",
    "40" => "270",
    "41" => "275",
    "42" => "260",
    "45" => "267",
    "46" => "269",
    "47" => "276",
    "48" => "278",
    "49" => "265",
    "50" => "271",
    "51" => "263",
    "52" => "266",
    "55" => "262",
    "63" => "268",
    "65" => "277",
    "66" => "261",
    # End Premier League
    # Begin La Liga
    "540" => "287",
    "531" => "281",
    "530" => "282",
    "529" => "283",
    "724" => "204",
    "538" => "285",
    "797" => "206",
    "540" => "287",
    "546" => "288",
    "547" => "289",
    "720" => "290",
    "798" => "291",
    "727" => "292",
    "728" => "293",
    "543" => "294",
    "541" => "295",
    "548" => "296",
    "536" => "297",
    "532" => "298",
    "533" => "299",
    # End La Liga
    # Begin Ligue 1
    "77" => "300",
    "79" => "305",
    "80" => "307",
    "81" => "308",
    "82" => "311",
    "83" => "312",
    "84" => "313",
    "85" => "314",
    "91" => "310",
    "93" => "315",
    "94" => "316",
    "95" => "318",
    "96" => "317",
    "97" => "306",
    "98" => "301",
    "99" => "303",
    "106" => "302",
    "108" => "309",
    "110" => "319",
    "116" => "304",
    # End Ligue 1
    # Begin Serie A
    "487" => "330",
    "488" => "335",
    "489" => "320",
    "492" => "331",
    "494" => "338",
    "496" => "329",
    "497" => "332",
    "498" => "334",
    "499" => "321",
    "500" => "322",
    "502" => "325",
    "503" => "337",
    "504" => "327",
    "505" => "328",
    "511" => "324",
    "514" => "333",
    "515" => "336",
    "520" => "323",
    "867" => "326",
    "1579" => "339"
    # End Serie A
  }
  return ids_hash[api_id.to_s]
end

leagues = [39, 140, 61, 135]

desc "This task is called by the Heroku scheduler add-on"
task :getfixtures => :environment do
  #require 'uri'
  #require 'net/http'
  #require 'openssl'

  # url = URI("https://v3.football.api-sports.io/leagues?type=league&season=2021&country=France")
  # url = URI("https://v3.football.api-sports.io/fixtures/rounds?season=2021&league=61")
  # url = URI("https://v3.football.api-sports.io/fixtures?date=2021-08-21&season=2021&league=135")
  # url = URI("https://v3.football.api-sports.io/standings?season=2021&league=135")

  #leagues = [39, 140, 61, 135]
  today = Date.today
  tomo = Date.tomorrow.strftime("%Y-%m-%d")
  day_after_tomo = (Date.tomorrow + 1.day).strftime("%Y-%m-%d")
  day2_after_tomo = (Date.tomorrow + 2.days).strftime("%Y-%m-%d")
  url = ""
  leagues.each do |league|
    url = URI("https://v3.football.api-sports.io/fixtures?date=" +
          day_after_tomo + "&season=2022&league=" + league.to_s)

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(url)
    request["x-rapidapi-host"] = 'v3.football.api-sports.io'
    request["x-rapidapi-key"] = ENV['API_FOOTBALL_KEY']

    response = http.request(request)
    puts response.read_body
    @obj = JSON.parse(response.read_body, object_class: OpenStruct)
    @fixtures = @obj.response
    #puts "fixtures count = " + @fixtures.size.to_s
    #puts get_rails_team_id(42.to_s)

    @my_league = League.find(get_rails_league_id(league))
    @fixtures.each do |fixture|
      @match = Match.new
      @match.league_id = @my_league.id
      @match.home_team_id = get_rails_team_id(fixture.teams.home.id)
      @match.away_team_id = get_rails_team_id(fixture.teams.away.id)
      @match.home_goals = nil
      @match.away_goals = nil
      @match.match_date_time = DateTime.strptime(fixture.fixture.timestamp.to_s, '%s').in_time_zone("Paris")
      if Match.where("home_team_id=? and away_team_id=? and match_date_time > ?",
        @match.home_team_id, @match.away_team_id, DateTime.now).count == 0
        # create match
        @match.save
      end
    end
  end

end


task :get_standings => :environment do
  # do something
  #leagues = [39, 140, 61, 135]
  leagues.each do |league|
    @my_league = League.find(get_rails_league_id(league).to_i)
    @nb_recent_matches = @my_league.matches.where("match_date_time < ? and match_date_time > ?",DateTime.now - 2.hours, DateTime.now - 5.hours).count

    if @nb_recent_matches > 0
      # get fixutres for league
      url = URI("https://v3.football.api-sports.io/standings?season=2022&league=" + league.to_s)

      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      request = Net::HTTP::Get.new(url)
      request["x-rapidapi-host"] = 'v3.football.api-sports.io'
      request["x-rapidapi-key"] = ENV['API_FOOTBALL_KEY']

      response = http.request(request)
      #puts response.read_body
      @obj = JSON.parse(response.read_body, object_class: OpenStruct)
      @standings = @obj.response[0].league.standings[0]
      #puts "size = " + @standings.size.to_s
      @standings.each do |s|
        @rails_team_id = get_rails_team_id(s.team.id)
        #puts s.rank.to_s + ': ' + s.team.name + '(' + s.points.to_s + ')'
        @rails_team = Team.find(@rails_team_id)
        @rails_team.update_columns(league_position: s.rank, league_points: s.points)
      end
    end
  end
end
