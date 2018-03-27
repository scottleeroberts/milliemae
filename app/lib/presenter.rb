class Presenter < SimpleDelegator
  def self.methods_for_enum(column_name)
    define_method "#{ column_name }s" do
      model.class.public_send("#{ column_name }s")
    end

    define_method "titlecase_#{ column_name }" do
      -> (e) { titleize e.first }
    end

    define_method "#{ column_name }_value" do
      -> (e) { e.first }
    end
  end

  def self.presents(name)
    alias_method name, :model
  end

  def initialize(model:, view:)
    @model = model
    @view = view

    super(model)
  end

  private
  attr_reader :model, :view

  def current_tenant
    ActsAsTenant.current_tenant
  end

  def icon(font_awesome_icon_class, *additional_classes)
    classes = [ 'fa', "fa-#{font_awesome_icon_class}" ] + additional_classes

    view.content_tag(:i, class: classes.join(' ')) { '' }
  end
end
