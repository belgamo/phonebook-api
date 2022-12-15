module RequestHelpers
  def parse_json(value = response.body) 
    JSON.parse(value, symbolize_names: true)
  end
end

RSpec.configure do |config|
  config.include RequestHelpers, type: :request
end