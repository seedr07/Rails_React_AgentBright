module ScaffoldHelper

  def page_header(options={}, &block)
    if block
      options.merge!(body: capture(&block))
    end

    render(partial: "shared/scaffold/page_header", locals: options)
  end

end
