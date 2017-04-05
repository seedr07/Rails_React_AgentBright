module AvatarHelper

  def display_user_avatar(user, size, helper_class)
    image = user.profile_image
    url = user.profile_image_url
    initials = user.initials
    bg_class = user.avatar_class
    if image
      "<span class='initials-#{size} #{helper_class} user-avatar' style='background-image: url(#{url});'></span>"
    else
      "<span class='initials-#{size} #{helper_class} #{bg_class}'>#{initials.upcase}</span>"
    end
  end

  def display_assigned_to_avatar(user)
    image = user.profile_image
    url = user.profile_image_url
    initials = user.initials
    bg_class = user.avatar_class
    if image
      "<span class='assigned-to-avatar user-avatar' style='background-image: url(#{url});'></span>"
    else
      "<span class='assigned-to-avatar assigned-to-initials #{bg_class}'>#{initials.upcase}</span>"
    end
  end

  def display_initials_and_color_from_message(message, user, contact)
    user_or_contact = GetUserOrContactFromMessageService.process(message, user, contact)

    if user_or_contact.present?
      "<span class='user-avatar #{user_or_contact.avatar_class}'>#{user_or_contact.initials.upcase}</span>"
    else
      names = message.from.map { |h| h["name"] }

      first_name, last_name = names.first.split(" ")
      initials = get_initials_from_names(first_name, last_name)

      "<span class='user-avatar abg0'>#{initials}</span>"
    end
  end

  def display_user_circle(user, size: 50)
    image = user.profile_image
    url = user.profile_image_url
    initials = user.initials.upcase
    helper_class = "circle"
    if image
      "<img src='#{url}' class='avatar-#{size} #{helper_class}'>"
    else
      "<span class='initials-#{size} #{helper_class}'>#{initials}</span>"
    end
  end

end
