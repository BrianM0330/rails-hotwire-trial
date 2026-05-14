module ApplicationHelper
  def inline_svg(filename, css_class:, **attributes)
    path = Rails.root.join("app/assets/images", filename)
    svg = path.read
    html_attributes = tag.attributes(attributes.merge(class: css_class))

    svg.sub("<svg", "<svg #{html_attributes}").html_safe
  end
end
