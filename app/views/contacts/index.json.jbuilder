# Specify the partial, as well as the name of the variable used in the partial
json.contacts @contacts do |contact|
  json.extract!(
    contact,
    :id,
    :first_name,
    :name,
    :last_name,
    :grade,
    :grade_to_s,
    :email,
    :created_at,
    :updated_at,
    :profession,
    :company,
    :initials,
    :avatar_color
  )
  json.phone_number number_to_phone(contact.phone_number, area_code: true)
  json.last_contacted_date cal_date(contact.last_contacted_date)
  # json.groups contact.contact_groups_by_user(contact.user) do |group|
  #   json.name group
  # end
end
