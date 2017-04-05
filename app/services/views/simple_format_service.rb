class Views::SimpleFormatService
  include ActionView::Helpers::TextHelper

  def self.convert(text, html_options={}, options={})
    self.new.convert(text, html_options, options)
  end

  def convert(text, html_options={}, options={})
    simple_format(text, html_options, options)
  end
end
