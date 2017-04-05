module TabsHelper

  def nav_tab(label, link, icon_class=nil, li_class=nil)
    content_tag(:li, class: li_class ) do
      link_to(link, { class: "withoutripple", :data => { :toggle => "tab" } }) do
        if icon_class.present?
          concat(content_tag(:div, class: "tab-icon") do
            content_tag(:span, "", class: icon_class)
          end)
        end
        concat(content_tag(:div, label, class: "tab-label"))
      end
    end
  end

  def id_nav_tab(label, link, icon_class=nil, li_class=nil, id)
    content_tag(:li, class: li_class) do
      link_to(link, { class: "withoutripple", :data => { :toggle => "tab" }, :id => id }) do
        if icon_class.present?
          concat(content_tag(:div, class: "tab-icon") do
            content_tag(:span, "", class: icon_class)
          end)
        end
        concat(content_tag(:div, label, class: "tab-label"))
      end
    end
  end

end