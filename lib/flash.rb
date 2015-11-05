class Flash

  attr_accessor :flash_cookie_contents
  attr_reader :later
  
  def initialize(req)
    if req.cookies
      req.cookies.each do |cookie|
        if cookie.name == '_rails_lite_flash'
          @flash_cookie_contents = JSON.parse(cookie.value)
        end
      end

      if @flash_cookie_contents
        @flash_cookie_contents.each do |key, val|
          @data[key] = val
        end
      end

    end
    @later = {}
    @data ||= {}
  end

  def []=(key, value)
    @later[key] = value  # or @data[key] if later is nil
  end

  def now(key, val)     #flash.now[:key] = value   #  swap later to data
    @data[key] = val
  end

  def [](key)
    @data[key]
  end

  def store_flash_cookie(res)
    flash_cookie_contents = self.later.to_json
    flash_cookie = WEBrick::Cookie.new('_rails_lite_flash', flash_cookie_contents)
    res.cookies << flash_cookie
  end

end
