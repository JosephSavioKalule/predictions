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
          day2_after_tomo + "&season=2021&league=" + league.to_s)

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



## Leagues ##
#  39 - Premier League
# 140 - La Liga
#  61 - Ligue 1
# 135 - Serie A

## Teams ##
# Arsenal 42
# Brentford 55
# Burnley 44
# Brighton 51
# Chelsea 49
# Crystal Palace 52
# Everton 45
# Southampton 41
# Leicester 46
# Wolves 39
# Manchester United 33
# Leeds 63
# Norwich 71
# Liverpool 40
# Watford 38
# Aston Villa 66
# Newcastle 34
# West Ham 48
# Tottenham 47
# Manchester City 50


# [[199, "Wolverhampton Wanderers"], [198, "West Ham United"], [197, "Watford"], [196, "Tottenham Hotspur"], [195, "Southampton"], [194, "Norwich City"], [193, "Newcastle United"], [192, "Manchester United"], [191, "Manchester City"], [190, "Liverpool"], [189, "Leicester City"], [188, "Leeds United"], [187, "Everton"], [186, "Crystal Palace"], [185, "Chelsea"], [184, "Burnley"], [183, "Brighton & Hove Albion"], [182, "Brentford"], [181, "Aston Villa"], [180, "Arsenal"]]

# Alaves 542
# Athletic Bilbao 531
# Atletico Madrid 530
# Barcelona 529
# Cadiz 724
# Celta Vigo 538
# Elche 797
# Espanyol 540
# Getafe 546
# Granada 715
# Levante 539
# Mallorca 798
# Osasuna 727
# Rayo Vallecano 728
# Real Betis 543
# Real Madrid 541
# Real Sociedad 548
# Sevilla 536
# Valencia 532
# Villarreal 533

# [[219, "Villarreal"], [218, "Valencia"], [217, "Sevilla"], [216, "Real Sociedad"], [215, "Real Madrid"], [214, "Real Betis"], [213, "Rayo Vallecano"], [212, "Osasuna"], [211, "Mallorca"], [210, "Levante"], [209, "Granada"], [208, "Getafe"], [207, "Espanyol"], [206, "Elche"], [205, "Celta Vigo"], [204, "Cádiz"], [203, "Barcelona"], [202, "Atletico Madrid"], [201, "Athletic Bilbao"], [200, "Alavés"]]

# Angers 77
# Bordeaux 78
# Brest 106
# Clermont Foot 99
# Lens 116
# Lille 79
# Lorient 97
# Lyon 80
# Marseille 81
# Metz 112
# Monaco 91
# Montpellier 82
# Nantes 83
# Nice 84
# PSG 85
# Reims 93
# Rennes 94
# Saint Etienne 1063
# Strasbourg 95
# Troyes 110

# [[239, "Troyes"], [238, "Strasbourg"], [237, "Saint-Etienne"], [236, "Rennes"], [235, "Reims"], [234, "Paris Saint Germain"], [233, "Nice"], [232, "Nantes"], [231, "Montpellier"], [230, "Monaco"], [229, "Metz"], [228, "Marseille"], [227, "Lyon"], [226, "Lorient"], [225, "Lille"], [224, "Lens"], [223, "Clermont"], [222, "Brest"], [221, "Bordeaux"], [220, "Angers"]]


# AC Milan 489
# Atalanta 499
# Bologna 500
# Cagliari 490
# Empoli 511
# Fiorentina 502
# Genoa 495
# Inter 505
# Juventus 496
# Lazio 487
# Napoli 492
# Roma 497
# Salernitana 514
# Sampdoria 498
# Sassuolo 488
# Spezia 515
# Torino 503
# Udinese 494
# Venezia 517
# Verona 504

# [[259, "Venezia"], [258, "Udinese"], [257, "Torino"], [256, "Spezia"], [255, "Sassuolo"], [254, "Sampdoria"], [253, "Salernitana"], [252, "Roma"], [251, "Napoli"], [250, "Lazio"], [249, "Juventus"], [248, "Inter"], [247, "Hellas Verona"], [246, "Genoa"], [245, "Fiorentina"], [244, "Empoli"], [243, "Cagliari"], [242, "Bologna"], [241, "Atalanta"], [240, "AC Milan"]]

task :get_standings => :environment do
  # do something
  #leagues = [39, 140, 61, 135]
  leagues.each do |league|
    @my_league = League.find(get_rails_league_id(league).to_i)
    @nb_recent_matches = @my_league.matches.where("match_date_time < ? and match_date_time > ?",DateTime.now - 2.hours, DateTime.now - 5.hours).count

    if @nb_recent_matches > 0
      # get fixutres for league
      url = URI("https://v3.football.api-sports.io/standings?season=2021&league=" + league.to_s)

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
