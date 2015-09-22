require_relative '../phase2/controller_base'
require 'active_support'
require 'active_support/core_ext'
require 'erb'
require 'active_support/inflector'

module Phase3
  class ControllerBase < Phase2::ControllerBase
    # use ERB and binding to evaluate templates
    # pass the rendered html to render_content
    def render(template_name)
    # use File.read to read in a template file - views/#{controller_name}/#{template_name}.html.erb
      controller_name = self.class.to_s.underscore
      erbfile = File.read("./views/#{controller_name}/#{template_name}.html.erb")  
      # create new ERB template from contents
      template = ERB.new(erbfile).result(binding)
      # us binding to capture the controller's instance variables
      render_content(template, "text/html")
    end
  end
end
