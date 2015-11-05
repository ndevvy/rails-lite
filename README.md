# Rails Lite
A metaprogramming project in which I wrote the basic functionality of Rails's controller base class and router. See /lib/ for the implementations.

## ControllerBase
  - Can redirect or render and tracks whether a response has already been built such that render and redirect can only happen once per controller action
  - #render(template_name) will locate the right template in the file structure and add it to the request body, binding any instance variables from the Session for use in the template
  - Uses a Session object for cookie management and a Params object for storing params
  - Stores information to a Flash object to be displayed on redirect or render

### Session
  - Reads cookies from the request, stores cookie contents, and adds cookies to the response

### Params
  - Stores params from the route, query string, and request body
  - Parses query string and request body params using URI::decode_www_form
  - Parses keys and builds nested hashes

### Flash
  - Stores information (such as messages or errors), to be accessed & rendered by the views
  - Can persist data through one redirect (by storing in a cookie for the next Flash to pick up) or show it on render (by storing in an instance variable that won't persist in a cookie)

## Router
  - Builds out default Routes for HTTP methods
  - Matches the correct route to the request, based on path and HTTP method

### Route
  - Parses route params using a given regular expression for the path
  - Instantiates the appropriate Controller, passing it the action to run, along with any route params
