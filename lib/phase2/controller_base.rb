module Phase2
  class ControllerBase

    attr_reader :req, :res
    attr_reader :already_built_response

    # Setup the controller
    def initialize(req, res)
      @req = req
      @res = res
    end

    # Helper method to alias @already_built_response
    def already_built_response?
      !!self.already_built_response
    end

    # Set the response status code and header
    def redirect_to(url)
      raise "Response already built" if already_built_response?
      @res.header['location'] = url
      @res.status=(200)
      @already_built_response = true
    end

    # Populate the response with content.
    # Set the response's content type to the given type.
    # Raise an error if the developer tries to double render.
    def render_content(content, content_type)
      raise "Response already built" if already_built_response?
      @res.content_type = content_type
      @res.body = content
      @already_built_response = true
    end
  end
end
