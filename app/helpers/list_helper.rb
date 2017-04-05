module ListHelper

  def fixed_list_item(title, description)
    content_tag(:li, class: "clearfix") do
      concat(content_tag(:span, title, class: "title"))
      concat(content_tag(:span, description, class: "description"))
    end
  end

  def fixed_list_header(header, edit_link=nil, link_id=nil, collapse_id=nil)
    content_tag(:div, class: "section-header") do
      if edit_link.present?
        concat(content_tag(:div, class: "section-header-edit") do
          link_to(
            "EDIT",
            edit_link,
            class: "btn btn-paper btn-loading",
            data: { list_edit: true, loading_text: "Loading..." },
            id: link_id,
            remote: true
          )
        end)
      end
      if collapse_id.present?
        concat(content_tag(:a, class: "clickable collapsed", data: { toggle: "collapse",
               toggle_event: "true", target: "##{collapse_id}" }) do
          concat(content_tag(:h4) do
            concat(content_tag(:span, "", class: "title-arrow fui-arrow-right"
                              ))
            concat(header)
          end)
        end)
      else
        concat(content_tag(:h4, header))
      end
    end
  end

  def action_list_item(options={})
    # Required arguments: title, description, icon_class
    # Optional arguments: link, link_data_method,
    # link_attributes, icon_attribtues

    options[:link] = nil unless options[:link].present?
    options[:link_attributes] = nil unless options[:link_attributes].present?
    options[:icon_attributes] = nil unless options[:icon_attributes].present?

    if options[:link_data_method].present?
      options[:data_method] = "data-method=#{options[:link_data_method]}"
    else
      options[:data_method] = nil
    end

    render(partial: "shared/action_list_item", locals: options)
  end

end
