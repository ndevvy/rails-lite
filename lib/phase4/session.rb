require 'json'
require 'webrick'
require 'byebug'

module Phase4
  class Session
    # find the cookie for this app
    # deserialize the cookie into a hash
    attr_reader :cookie_contents

    def initialize(req)
      req.cookies.each do |cookie|
        if cookie.name == '_rails_lite_app'
          @cookie_contents = JSON.parse(cookie.value)

        end
      end
      @cookie_contents ||= {}
    end

    def [](key)
      self.cookie_contents[key]
    end

    def []=(key, val)
      self.cookie_contents[key] = val
    end

    # serialize the hash into json and save in a cookie
    # add to the responses cookies
    def store_session(res)
      cookie_contents = self.cookie_contents.to_json
      cookie = WEBrick::Cookie.new('_rails_lite_app', cookie_contents)
      res.cookies << cookie
    end
  end
end
