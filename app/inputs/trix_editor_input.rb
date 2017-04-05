class TrixEditorInput < SimpleForm::Inputs::Base

  def input(wrapper_options=nil)
    merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)

    input_markup = @builder.text_field(attribute_name, merged_input_options).html_safe

    tag = String.new
    tag << input_markup
    tag << "<trix-editor input='#{trix_message_content(input_markup)}' class='trix-content'>".html_safe
    tag << "</trix-editor>".html_safe
    tag
  end

  protected

  def input_html_options
    { type: "hidden" }
  end

  private

  def trix_message_content(input_markup)
    input_markup.scan(/id="([^"]*)"/).first.first.to_s
  end

end
