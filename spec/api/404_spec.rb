require 'spec_helper'

describe Api do
  include Api::Test::EndpointTest

  context '404' do
    it 'returns a plain 404' do
      get '/foobar'
      expect(last_response.status).to eq 404
      expect(last_response.body).to eq "File not found: /foobar\n"
    end
  end
end
