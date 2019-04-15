desc "This task is called by the Heroku scheduler add-on"

task :send_reminders => :environment do
  
  @upcoming_matches = Match.where("match_date_time > ? and match_date_time < ?", 61.minutes.from_now, 2.days.from_now)
  if @upcoming_matches.count > 0 && Date.today.friday?
    # there's some matches
    @all_users = User.all
    @users = []
    @all_users.each do |user|
      if user.settings_box.receive_email
        @num_predictions = user.predictions.count
        if @num_predictions > 0
          @days_since_last_prediction = (Time.now - user.predictions.last.created_at)/1.days
          if @days_since_last_prediction > 7
            @should_send_email = true
          else
            @should_send_email = false
          end
        else
          if (Time.now - user.created_at)/1.days > 6
            @should_send_email = true
          else
            @should_send_email = false
          end
        end
      else
        @should_send_email = false
      end
      
      if @should_send_email
        @users.push(user)
      end
    end
    
    puts "Going to send #{@users.count} #{'email'.pluralize(@users.count)}..."
    @users.each do |u| 
      u.send_reminder
      puts "Reminder sent to #{u.email}"
    end
    puts "Done sending #{@users.count} #{'email'.pluralize(@users.count)}..."
  else
    # no matches
    puts "No upcoming matches. No email"
  end
    
end