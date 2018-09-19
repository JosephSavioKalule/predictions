desc "This task is called by the Heroku scheduler add-on"

task :send_reminders => :environment do
  @all_users = User.all
  @users = []
  @all_users.each do |user|
    @num_predictions = user.predictions.count
    if @num_predictions > 0
      @days_since_last_prediction = (Time.now - user.predictions.last.created_at)/1.days
      if @days_since_last_prediction > 7
        @should_send_email = true
      end
    else
      if (Time.now - User.first.created_at)/1.days > 6
        @should_send_email = true
      end
    end
    
    if @should_send_email
      @users.push(user)
    end
  end
  
  if @users.count > 0
    User.send_reminders @users
  end
end