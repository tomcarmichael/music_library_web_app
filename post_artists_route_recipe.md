
# POST /artists Route Design Recipe

_Copy this design recipe template to test-drive a Sinatra route._

## 1. Design the Route Signature

You'll need to include:
  * the HTTP method
  * the path
  * any query parameters (passed in the URL)
  * or body parameters (passed in the request body)

## 2. Design the Response

`200 OK`
- check that artist has been added to DB using all method


## 3. Write Examples

_Replace these with your own design._

```
# Request:

POST /artists 

# With body parameters:
name=Wild nothing
genre=Indie

# Then subsequent request:
GET /artists

# Expected response (200 OK)
Pixies, ABBA, Taylor Swift, Nina Simone, Wild nothing
```

## 4. Encode as Tests Examples

```ruby
# EXAMPLE
# file: spec/integration/application_spec.rb

require "spec_helper"

describe Application do
  include Rack::Test::Methods

  let(:app) { Application.new }

  context "POST /artists" do
    it 'adds an artist to the DB' do
      response = post('/artists', name: "Wild nothing", genre: "Indie")
      expect(response.status).to eq(200)
      repo = AristRepository.new
      artists = repo.all
      expect(artists.length).to eq(5)
      expect(artists.first.name).to eq('Pixies')
      expect(artists.last.id).to eq(5)
      expect(artists.last.name).to eq('Wild Nothing')
      expect(artists.last.genre).to eq("Indie")
    end
  end
end
```

## 5. Implement the Route

Write the route and web server code to implement the route behaviour.
