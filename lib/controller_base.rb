require 'active_support'
require 'active_support/core_ext'
require 'erb'
require 'active_support/inflector'
require_relative './session'
require_relative './params'


class ControllerBase

  attr_reader :req, :res
  attr_reader :already_built_response, :params
  attr_accessor :flash

  # Setup the controller
  def initialize(req, res, route_params = {})
    @req = req
    @res = res
    @params = Params.new(req, route_params)
    @flash = Flash.new(req)
  end

  def flash
    @flash ||= Flash.new(new)
  end

  # Helper method to alias @already_built_response
  def already_built_response?
    !!self.already_built_response
  end

  # Accesses current session or creates a new one
  def session
    @session ||= Session.new(@req)
  end

  # Sets the response status code and header
  def redirect_to(url)
    raise "Response already built" if already_built_response?
    @res.header['location'] = url
    @res.status=(200)
    @already_built_response = true
    session.store_session(@res)
    flash.store_flash_cookie(res)
  end

  # Populates HTTP response with content
  def render_content(content, content_type)
    raise "Response already built" if already_built_response?
    @res.content_type = content_type
    @res.body = content
    @already_built_response = true
    session.store_session(@res)
    flash.store_flash_cookie(res)
  end

  # Takes a template name, reads from the appropriate file in /views/, and renders the content
  def render(template_name)
    controller_name = self.class.to_s.underscore
    erbfile = File.read("./views/#{controller_name}/#{template_name}.html.erb")
    template = ERB.new(erbfile).result(binding)
    render_content(template, "text/html")
  end

  # used with the router to call action_name (:index, :show, :create...)
  def invoke_action(name)
    self.send(name)
    unless already_built_response
      render(name)
    end
  end

end
