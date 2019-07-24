# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

if Rails.env.development?
  
end

if Rails.env.production?
  # seed production data here
end

# both environments

season = Season.find(2)

countries = Country.all

leagues = League.create!([
  { name: 'Premier League', country: countries[0], season: season },
  { name: 'La Liga', country: countries[1], season: season },
  { name: 'Ligue 1', country: countries[2], season: season },
  { name: 'Serie A', country: countries[3], season: season }
])

# to modify:
teams = Team.create!([
  # Premier league:
  { name: 'AFC Bournemouth', league: leagues[0] },
  { name: 'Arsenal', league: leagues[0] },                 # 2
  { name: 'Aston Villa', league: leagues[0] },
  { name: 'Brighton & Hove Albion', league: leagues[0] },
  { name: 'Burnley', league: leagues[0] },
  { name: 'Chelsea', league: leagues[0] },                 # 6
  { name: 'Crystal Palace', league: leagues[0] },
  { name: 'Everton', league: leagues[0] },                 # 8
  { name: 'Leicester City', league: leagues[0] },
  { name: 'Liverpool', league: leagues[0] },
  { name: 'Manchester City', league: leagues[0] },
  { name: 'Manchester United', league: leagues[0] },
  { name: 'Newcastle United', league: leagues[0] },
  { name: 'Norwich City', league: leagues[0] },
  { name: 'Sheffield United', league: leagues[0] },
  { name: 'Southampton', league: leagues[0] },             # 16
  { name: 'Tottenham Hotspur', league: leagues[0] },
  { name: 'Watford', league: leagues[0] },                 # 18
  { name: 'West Ham United', league: leagues[0] },
  { name: 'Wolverhampton Wanderers', league: leagues[0] },
  # La Liga:
  { name: 'Athletic Bilbao', league: leagues[1] },
  { name: 'Atletico Madrid', league: leagues[1] },
  { name: 'Barcelona', league: leagues[1] },               # 24
  { name: 'Celta Vigo', league: leagues[1] },
  { name: 'Deportivo Alaves', league: leagues[1] },
  { name: 'Eibar', league: leagues[1] },
  { name: 'Espanyol', league: leagues[1] },
  { name: 'Getafe', league: leagues[1] },
  { name: 'Granada', league: leagues[1] },
  { name: 'Leganes', league: leagues[1] },
  { name: 'Levante', league: leagues[1] },
  { name: 'Mallorca', league: leagues[1] },
  { name: 'Osasuna', league: leagues[1] },
  { name: 'Real Betis', league: leagues[1] },
  { name: 'Real Madrid', league: leagues[1] },
  { name: 'Real Sociedad', league: leagues[1] },
  { name: 'Real Valladolid', league: leagues[1] },
  { name: 'Sevilla', league: leagues[1] },
  { name: 'Valencia', league: leagues[1] },
  { name: 'Villarreal', league: leagues[1] },              # 40
  # Ligue 1:
  { name: 'Amiens', league: leagues[2] },
  { name: 'Angers', league: leagues[2] },                  # 42
  { name: 'Bordeaux', league: leagues[2] },
  { name: 'Brest', league: leagues[2] },                    # 44
  { name: 'Dijon', league: leagues[2] },
  { name: 'Lille', league: leagues[2] },
  { name: 'Lyon', league: leagues[2] },                    # 48
  { name: 'Marseille', league: leagues[2] },
  { name: 'Metz', league: leagues[2] },
  { name: 'Monaco', league: leagues[2] },
  { name: 'Montpellier', league: leagues[2] },
  { name: 'Nantes', league: leagues[2] },                  # 52
  { name: 'Nice', league: leagues[2] },
  { name: 'Nimes', league: leagues[2] },
  { name: 'Paris Saint Germain', league: leagues[2] },
  { name: 'Reims', league: leagues[2] },                   # 56
  { name: 'Rennes', league: leagues[2] },
  { name: 'Saint-Etienne', league: leagues[2] },
  { name: 'Strasbourg', league: leagues[2] },
  { name: 'Toulouse', league: leagues[2] },                # 60
  # Serie A:
  { name: 'AC Milan', league: leagues[3] },
  { name: 'Atalanta', league: leagues[3] },                # 62
  { name: 'Bologna', league: leagues[3] },
  { name: 'Brescia', league: leagues[3] },
  { name: 'Cagliari', league: leagues[3] },
  { name: 'Fiorentina', league: leagues[3] },
  { name: 'Genoa', league: leagues[3] },
  { name: 'Hellas Verona', league: leagues[3] },
  { name: 'Inter', league: leagues[3] },                   # 70
  { name: 'Juventus', league: leagues[3] },
  { name: 'Lazio', league: leagues[3] },
  { name: 'Lecce', league: leagues[3] },
  { name: 'Parma Calcio 1913', league: leagues[3] }
  { name: 'Roma', league: leagues[3] },
  { name: 'Sampdoria', league: leagues[3] },
  { name: 'Sassuolo', league: leagues[3] },
  { name: 'SPAL 2013', league: leagues[3] },
  { name: 'SSC Napoli', league: leagues[3] },
  { name: 'Torino', league: leagues[3] },
  { name: 'Udinese', league: leagues[3] }
  ])