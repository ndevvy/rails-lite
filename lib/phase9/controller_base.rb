require_relative '../phase6/controller_base'
require 'byebug'

module Phase9
  class ControllerBase < Phase6::ControllerBase
    # use this with the router to call action_name (:index, :show, :create...)
    attr_accessor :flash

    def initialize(req, res, route_params = {})
      super
      @flash = Flash.new(req)
    end

    def flash
      @flash ||= Flash.new(new)
    end

    def redirect_to(url)
      super
      flash.store_flash_cookie(res)
    end

    def render_content(content, content_type)
      super
      flash.store_flash_cookie(res)
    end

  end
end
