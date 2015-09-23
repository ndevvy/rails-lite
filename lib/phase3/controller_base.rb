require_relative '../phase2/controller_base'
require 'active_support'
require 'active_support/core_ext'
require 'erb'
require 'active_support/inflector'

module Phase3
  class ControllerBase < Phase2::ControllerBase
    def render(template_name)
      controller_name = self.class.to_s.underscore
      erbfile = File.read("./views/#{controller_name}/#{template_name}.html.erb")
      template = ERB.new(erbfile).result(binding)
      render_content(template, "text/html")
    end
  end
end
