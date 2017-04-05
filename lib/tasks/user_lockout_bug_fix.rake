desc "updating selected accounts to free subscription status and the rest to expired"
task :user_lockout_bug_fix => :environment do
  free_subscription_email_list = ["annieogrady22@hotmail.com",
                                  "patrick@agentbright.com",
                                  "patrick@heyogrady.com",
                                  "karabethneike@gmail.com",
                                  "neeraj@bigbinary.com",
                                  "pdunphy@gmail.com",
                                  "annieogrady22@gmail.com",
                                  "vipul@bigbinary.com",
                                  "juliesellshouses@gmail.com",
                                  "johnogrady@rachelthomas.com",
                                  "garrett@agentbright.com",
                                  "annie@agentbright.com",
                                  "nsharmaknox@gmail.com",
                                  "phil@agentbright.com",
                                  "maureenogrady@rachelthomas.com",
                                  "laura.marsh@comcast.net"
                                  ]
  User.all.each do |user|
    if free_subscription_email_list.include?(user.email)
      user.subscription_account_status = 3
      user.save
    else
      user.subscription_account_status = 0
      user.save
    end
  end

end
