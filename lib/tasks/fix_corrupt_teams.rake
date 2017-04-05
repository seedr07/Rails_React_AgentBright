desc "fix team records with no user"
task :fix_corrupt_teams => :environment do

  Team.all.each do |t|
    user_id = t.user_id
    id = t.id
    # check if the Teammate user_id exists in the User db -
    Util.log("\nUser is: #{user_id}")
    @u = User.find_by_id(user_id)
    if @u
      # check if the User Id exists, then it belongs to a valid User still in our db
      Util.log("Team has user. USER ID: #{user_id}")
    else
    # if we can't find the original User (id) then we should delete the Team and Teammate record
      Util.log("User #{user_id} does not exist. Deleting team.")
      Team.destroy(id)
    end
  end
end