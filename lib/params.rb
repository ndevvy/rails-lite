require 'uri'

class Params
  # merges params from
  # 1. query string
  # 2. post body
  # 3. route params

  def initialize(req, route_params = {})
    @params = route_params
    @params.merge!(parse_www_encoded_form(req.query_string)) if req.query_string
    @params.merge!(parse_www_encoded_form(req.body)) if req.body
  end

  def [](key)
    @params[key.to_sym] || @params[key.to_s]
  end

  def to_s
    @params.to_s
  end

  class AttributeNotFoundError < ArgumentError; end;

  private
  # returns deeply nested hash
  # argument format:
  # user[address][street]=main&user[address][zip]=89436

  def query_string_params(query_string)
    params = {}
    parsed_query_string = parse_www_encoded_form(query_string)
    parsed_query_string.each do |el|
      params[el[0]] = params[el[1]]
    end
    params
  end

  def parse_www_encoded_form(www_encoded_form)
    params = {}
    decoded =  URI.decode_www_form(www_encoded_form)
    decoded.each do |keys, value|
      current = params
      keys = parse_key(keys)
        keys.each_with_index do |key, index|
          if index == keys.length - 1
            current[key] = value
          else
            current[key] ||= {}  # if there isn't a key already in the hash, add an empty hash
          end
            current = current[key]  # add to scope
        end
      end
      params
    end

  def parse_key(key)
    key_array = key.split(/\]\[|\[|\]/)
    return [key_array.first] if key.length == 1
    key_array
  end
end
