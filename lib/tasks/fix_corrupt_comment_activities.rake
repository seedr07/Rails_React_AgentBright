desc "fix comment activities that have invalid recipients"
task :fix_corrupt_comment_activities => :environment do
  activities = PublicActivity::Activity.where(trackable_type: "Comment", recipient_type: "Comment")

  Util.log("Number of activities: #{activities.count}")

  activities.each do |activity|
    # check if the comment still exists in our db; if so set equal to "comment"
    Util.log("\nExamining Activity ID: #{activity.id}")
    if comment = activity.trackable
      Util.log("Activity has comment. Comment ID: #{comment.id}")
      Util.log("Content: #{comment.content}")
   
      # check if what the comment belongs to (lead or contact) still exists in our db
      if comment.commentable
        Util.log("Comment has commentable - #{comment.commentable_type} ID: #{comment.commentable_id}. Fixing and saving.")
        # set the activity recipient as the lead or contact that the comment belongs to
        activity.recipient = comment.commentable
        activity.save!
   
      # if we can't find the original comment, and the original lead/contact object,
      # we should delete the activity.
      else
        Util.log("Comment #{comment.id} commentable does not exist. Deleting activity.")
        activity.destroy
      end
    else
      Util.log("Activity comment does not exist. Deleting activity.")
      activity.destroy
    end
  end
end
