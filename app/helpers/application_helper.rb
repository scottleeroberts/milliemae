module ApplicationHelper
  def present(model, presenter_class: nil)
    klass = presenter_class || "#{ model.class }Presenter".constantize
    presented_model = klass.new(model: model, view: self)

    yield presented_model if block_given?
    presented_model
  end

  def mobile?
    browser &&
      (
        browser.device.mobile? ||
        browser.device.tablet?
      )
  end
end

