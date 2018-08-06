# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

if Rails.env.development?
  User.create!(name:  "Example User",
               email: "example@example.com",
               password:              "foobar",
               password_confirmation: "foobar",
               admin: true,
               activated: true,
               activated_at: Time.zone.now)
  
  99.times do |n|
    name  = Faker::Name.name
    email = "example-#{n+1}@railstutorial.org"
    password = "password"
    User.create!(name:  name,
                 email: email,
                 password:              password,
                 password_confirmation: password,
                 activated: true,
                 activated_at: Time.zone.now)
  end
  
end

if Rails.env.production?
  # seed production data here
end

# both environments

seasons = Season.create!([{ start_year: 2018 }, { start_year: 2019}])

countries = Country.create!([{ name: 'England' }, { name: 'Spain' }, { name: 'France' }, { name: 'Italy' }])

leagues = League.create!([
  { name: 'Premier League', country: countries.first, season: seasons.first },
  { name: 'La Liga', country: countries.second, season: seasons.first },
  { name: 'Ligue 1', country: countries[2], season: seasons.first },
  { name: 'Serie A', country: countries[3], season: seasons.first }
])
  
teams = Team.create!([
  # Premier league:
  { name: 'AFC Bournemouth', league: leagues[0] },
  { name: 'Arsenal', league: leagues[0] },                 # 2
  { name: 'Brighton & Hove Albion', league: leagues[0] },
  { name: 'Burnley', league: leagues[0] },                 # 4
  { name: 'Cardiff City', league: leagues[0] },
  { name: 'Chelsea', league: leagues[0] },                 # 6
  { name: 'Crystal Palace', league: leagues[0] },
  { name: 'Everton', league: leagues[0] },                 # 8
  { name: 'Fulham', league: leagues[0] },
  { name: 'Huddersfield Town', league: leagues[0] },       # 10
  { name: 'Leicester City', league: leagues[0] },
  { name: 'Liverpool', league: leagues[0] },
  { name: 'Manchester City', league: leagues[0] },
  { name: 'Manchester United', league: leagues[0] },
  { name: 'Newcastle United', league: leagues[0] },
  { name: 'Southampton', league: leagues[0] },             # 16
  { name: 'Tottenham Hotspur', league: leagues[0] },
  { name: 'Watford', league: leagues[0] },                 # 18
  { name: 'West Ham United', league: leagues[0] },
  { name: 'Wolverhampton Wanderers', league: leagues[0] },
  # La Liga:
  { name: 'Deportivo Alaves', league: leagues[1] },
  { name: 'Athletic Bilbao', league: leagues[1] },         # 22
  { name: 'Atletico Madrid', league: leagues[1] },
  { name: 'Barcelona', league: leagues[1] },               # 24
  { name: 'Celta Vigo', league: leagues[1] },
  { name: 'Eibar', league: leagues[1] },                   # 26
  { name: 'Espanyol', league: leagues[1] },
  { name: 'Getafe', league: leagues[1] },                  # 28
  { name: 'Girona', league: leagues[1] },
  { name: 'SD Huesca', league: leagues[1] },
  { name: 'Leganes', league: leagues[1] },
  { name: 'Levante', league: leagues[1] },                 # 32
  { name: 'Rayo Vallecano', league: leagues[1] },
  { name: 'Real Betis', league: leagues[1] },
  { name: 'Real Madrid', league: leagues[1] },
  { name: 'Real Sociedad', league: leagues[1] },           # 36
  { name: 'Sevilla', league: leagues[1] },
  { name: 'Valencia', league: leagues[1] },
  { name: 'Real Valladolid', league: leagues[1] },
  { name: 'Villarreal', league: leagues[1] },              # 34
  # Ligue 1:
  { name: 'Amiens', league: leagues[2] },
  { name: 'Angers', league: leagues[2] },
  { name: 'Bordeaux', league: leagues[2] },
  { name: 'Caen', league: leagues[2] },
  { name: 'Dijon', league: leagues[2] },
  { name: 'Guingamp', league: leagues[2] },
  { name: 'Lille', league: leagues[2] },
  { name: 'Lyon', league: leagues[2] },
  { name: 'Marseille', league: leagues[2] },
  { name: 'Monaco', league: leagues[2] },
  { name: 'Montpellier', league: leagues[2] },
  { name: 'Nantes', league: leagues[2] },
  { name: 'Nice', league: leagues[2] },
  { name: 'Nimes', league: leagues[2] },
  { name: 'Paris Saint Germain', league: leagues[2] },
  { name: 'Reims', league: leagues[2] },
  { name: 'Rennes', league: leagues[2] },
  { name: 'Saint-Etienne', league: leagues[2] },
  { name: 'Strasbourg', league: leagues[2] },
  { name: 'Toulouse', league: leagues[2] },
  # Serie A:
  { name: 'AC Milan', league: leagues[3] },
  { name: 'Atalanta', league: leagues[3] },
  { name: 'Bologna', league: leagues[3] },
  { name: 'Cagliari', league: leagues[3] },
  { name: 'Chievo Verona', league: leagues[3] },
  { name: 'Empoli', league: leagues[3] },
  { name: 'Fiorentina', league: leagues[3] },
  { name: 'Frosinone', league: leagues[3] },
  { name: 'Genoa', league: leagues[3] },
  { name: 'Inter', league: leagues[3] },
  { name: 'Juventus', league: leagues[3] },
  { name: 'S.S. Lazio', league: leagues[3] },
  { name: 'Roma', league: leagues[3] },
  { name: 'Sampdoria', league: leagues[3] },
  { name: 'Sassuolo', league: leagues[3] },
  { name: 'SPAL 2013', league: leagues[3] },
  { name: 'SSC Napoli', league: leagues[3] },
  { name: 'Torino', league: leagues[3] },
  { name: 'Udinese', league: leagues[3] },
  { name: 'Parma Calcio 1913', league: leagues[3] }
  ])