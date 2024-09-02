require 'rails_helper'
require 'webmock/rspec'
require 'faraday'
require 'json'
require 'latest_stock_price/api'

RSpec.describe LatestStockPrice::API, type: :lib do
  before do
    @base_url = 'https://latest-stock-price.p.rapidapi.com'
    @api_key = ENV['RAPIDAPI_KEY']
  end

  describe '.price' do
    let(:stock_symbol) { 'AAPL' }
    let(:endpoint) { "/price?symbol=#{stock_symbol}" }
    let(:url) { "#{@base_url}#{endpoint}" }
    let(:response_body) { { "symbol" => stock_symbol, "price" => 150.0 }.to_json }

    before do
      stub_request(:get, url)
        .with(
          headers: {
            'Accept' => '*/*',
            'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
            'User-Agent' => 'Faraday v2.11.0',
            'X-RapidAPI-Key' => @api_key,
            'X-RapidAPI-Host' => 'latest-stock-price.p.rapidapi.com'
          }
        )
        .to_return(status: 200, body: response_body, headers: {})
    end

    it 'returns the correct stock price' do
      response = LatestStockPrice::API.price(stock_symbol)
      expect(response).to eq(JSON.parse(response_body))
    end

    it 'handles errors from Faraday' do
      stub_request(:get, url).to_raise(Faraday::Error.new('error'))

      response = LatestStockPrice::API.price(stock_symbol)
      expect(response).to eq({ 'error' => 'Request failed: error' })
    end
  end
end
