class SuiSelectInput < SimpleForm::Inputs::CollectionSelectInput

  protected

  def input_html_options
    {
      class: "ui dropdown",
      "data-ui-behavior": "dropdown"
    }
  end

end
