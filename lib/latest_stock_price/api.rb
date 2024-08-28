module LatestStockPrice
  class API
    BASE_URL = 'https"//latest-stock-price.p.rapidapi.com'

    def self.price(stock_symbol)
      request("/price?symbol=#{stock_symbol}")
    end

    def self.prices(stock_symbols)
      request("/prices?symbols=#{stock_symbols.join(',')}")
    end

    def self.price_all
      request('/price_all')
    end

    private

    def self.request(endpoint)
      response = Faraday.get("#{BASE_URL}#{endpoint}") do |req|
        req.headers['X-RapidAPI-Key'] = ENV['RAPIDAPI_KEY']
        req.headers['X-RapidAPI-Host'] = 'latest-stock-price.p.rapidapi.com'
      end
      JSON.parse(response.body)
    rescue StandardError => e
      { error: e.message }
    end
  end
end
