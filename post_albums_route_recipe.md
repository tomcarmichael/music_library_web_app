# POST /albums Route Design Recipe

_Copy this design recipe template to test-drive a Sinatra route._

## 1. Design the Route Signature

You'll need to include:
  * the HTTP method
  * the path
  * any query parameters (passed in the URL)
  * or body parameters (passed in the request body)

## 2. Design the Response

The route might return different responses, depending on the result.

For example, a route for a specific blog post (by its ID) might return `200 OK` if the post exists, but `404 Not Found` if the post is not found in the database.

Your response might return plain text, JSON, or HTML code. 

_Replace the below with your own design. Think of all the different possible responses your route will return._

`200 OK`


## 3. Write Examples

_Replace these with your own design._

```
# Request:

POST /albums 

# With body parameters:
title=Voyage
release_year=2022
artist_id=2

# Expected response (200 OK)
(No content)
```

## 4. Encode as Tests Examples

```ruby
# EXAMPLE
# file: spec/integration/application_spec.rb

require "spec_helper"

describe Application do
  include Rack::Test::Methods

  let(:app) { Application.new }

  context "POST /albums" do
    it 'returns 200 OK' do
      response = post('/albums', title: "Voyage", release_year: 2022, artist_id: 2)
      expect(response.status).to eq(200)
      repo = AlbumRepository.new
      albums = repo.all
      expect(albums.length).to eq(13)
      expect(albums.first.title).to eq('Doolittle')
      expect(albums.first.artist_id).to eq(1)
      expect(albums.last.artist_id).to eq(2)
      expect(albums.last.title).to eq('Voyage')
      expect(albums.last.release_year).to eq(2022)
    end
  end
end
```

## 5. Implement the Route

Write the route and web server code to implement the route behaviour.
