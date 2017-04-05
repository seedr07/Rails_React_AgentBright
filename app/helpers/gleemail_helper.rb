module GleemailHelper

  def gm_box(options={}, &block)
    options.merge!(body: capture(&block))
    render(partial: "shared/gleemail/gm_box", locals: options)
  end

  def mc_partial(partial, options={}, &block)
    if block
      options.merge!(body: capture(&block))
    end

    render(partial: "shared/mailchimp/#{partial}", locals: options)
  end

end
