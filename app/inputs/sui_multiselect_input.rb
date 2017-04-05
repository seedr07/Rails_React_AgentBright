class SuiMultiselectInput < SimpleForm::Inputs::SuiSelectInput

  protected

  def input_html_options
    super.push("multiple: ''")
  end

end
