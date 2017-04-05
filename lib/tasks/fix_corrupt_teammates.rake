desc "fix team records with no user"
task :fix_corrupt_teammates => :environment do

  Teammate.all.each do |teammate|
    user_id = teammate.user_id
    t = teammate.id
    # check if the Teammate user_id exists in the User db -
    Util.log("\nUser is: #{user_id}")
    @u = User.find_by_id(user_id)
    if @u
      # check if the User Id exists, then it belongs to a valid User still in our db
      Util.log("Teammate has user. USER ID: #{user_id}")
    else
    # if we can't find the original User (id) then we should delete the Team and Teammate record
      Util.log("User #{user_id} does not exist. Deleting teammate.")
      Teammate.destroy(t)
    end
  end
end