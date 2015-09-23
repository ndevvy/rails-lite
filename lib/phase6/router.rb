require 'active_support/inflector'

module Phase6
  class Route
    attr_reader :pattern, :http_method, :controller_class, :action_name, :regex

    def initialize(pattern, http_method, controller_class, action_name)
      @pattern, @http_method, @controller_class, @action_name = pattern,
        http_method, controller_class, action_name
      @regex = Regexp.new(pattern.to_s)
    end

    # checks if pattern matches path and method matches request method
    def matches?(req)
      regex.match(req.path) && req.request_method.downcase.to_sym == self.http_method
    end

    # use pattern to pull out route params (save for later?)
    # instantiate controller and call controller action
    def run(req, res)
      params = grab_route_params(req)
      controller = controller_class.new(req, res, params).invoke_action(action_name)
    end

    def grab_route_params(req)
      match_data = regex.match(req.path)
      if match_data
        route_params = {}
        match_data.names.each do |name|
          route_params[name] = match_data[name]
        end
        route_params
      end
    end



  end

  class Router
    attr_reader :routes

    def initialize
      @routes = []
    end

    # simply adds a new route to the list of routes
    def add_route(pattern, method, controller_class, action_name)
      @routes << Route.new(pattern, method, controller_class, action_name)
    end


    # evaluate the proc in the context of the instance
    # for syntactic sugar :)
    def draw(&proc)
      self.instance_eval(&proc)
    end

    # make each of these methods that
    # when called add route
    [:get, :post, :put, :delete].each do |http_method|
      define_method(http_method) do |pattern, controller_class, action_name|
        add_route(pattern, http_method, controller_class, action_name )
      end
    end

    # should return the route that matches this request
    def match(req)
      match = @routes.find { |route| route.matches?(req) }
      return match if match
      nil
    end

    # either throw 404 or call run on a matched route
    def run(req, res)
      route = match(req)
      if !route
        res.status = 404
        return
      else
        route.run(req, res)
      end
    end

  end
end
