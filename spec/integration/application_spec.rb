require "spec_helper"
require "rack/test"
require_relative '../../app'

def reset_albums_table

  seed_sql = File.read('spec/seeds/albums_seeds.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library_test' })
  connection.exec(seed_sql)
end

def reset_artists_table

  seed_sql = File.read('spec/seeds/artists_seeds.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'music_library_test' })
  connection.exec(seed_sql)
end

describe Application do
  before(:each) do
    reset_albums_table
    reset_artists_table
  end
  # This is so we can use rack-test helper methods.
  include Rack::Test::Methods

  # We need to declare the `app` value by instantiating the Application
  # class so our tests work.
  let(:app) { Application.new }

  context "POST /albums" do
    it 'Adds an album to the DB' do
      response = post('/albums', title: "Voyage", release_year: 2022, artist_id: 2)
      expect(response.status).to eq(200)
      repo = AlbumRepository.new
      albums = repo.all
      expect(albums.length).to eq(13)
      expect(albums.first.title).to eq('Doolittle')
      expect(albums.first.artist_id).to eq(1)
      expect(albums.last.artist_id).to eq(2)
      expect(albums.last.title).to eq('Voyage')
      expect(albums.last.release_year).to eq('2022')
    end
  end

  context "GET /artists" do
    it 'returns a list of links to all artists' do
      response = get('/artists')
      expect(response.status).to eq(200)
      expect(response.body).to include('<a href="/artists/1">Pixies</a>')
      expect(response.body).to include('<a href="/artists/4">Nina Simone</a>')
      expect(response.body).to include('<a href="/artists/2">ABBA</a>')
    end
  end

  context "GET /artists/:id" do
    it 'Returns the HTML content for artist of ID #1' do
      response = get('/artists/1')
      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Pixies</h1>')
      expect(response.body).to include('Genre: Rock')
    end

    it 'Returns the HTML content for album of ID #4' do
      response = get('/artists/4')
      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Nina Simone</h1>')
      expect(response.body).to include('Genre: Pop')
    end
  end


  context "POST /artists" do
    it 'adds an artist to the DB' do
      response = post('/artists', name: "Wild Nothing", genre: "Indie")
      expect(response.status).to eq(200)
      repo = ArtistRepository.new
      artists = repo.all
      expect(artists.length).to eq(5)
      expect(artists.first.name).to eq('Pixies')
      expect(artists.last.id).to eq(5)
      expect(artists.last.name).to eq('Wild Nothing')
      expect(artists.last.genre).to eq("Indie")
    end
  end

  context "GET /albums/:id" do
    it 'Returns the HTML content for album of ID #1' do
      response = get('/albums/1')
      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Doolittle</h1>')
      expect(response.body).to include('Release year: 1989')
    end

    it 'Returns the HTML content for album of ID #2' do
      response = get('/albums/2')
      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Surfer Rosa</h1>')
      expect(response.body).to include('Release year: 1988')
    end
  end

  context "GET /albums" do
    it "returns a list of albums within HTML content" do
      response = get('/albums')
      expect(response.status).to eq(200)
      expect(response.body).to include('<h1>Albums</h1>')
      expect(response.body).to include('<div>Title: Doolittle')
      expect(response.body).to include('Released: 1988')
    end

    it "Generates links for each album by id" do
      response = get('/albums')
      expect(response.status).to eq(200)
      expect(response.body).to include('<a href="/albums/1"')
      expect(response.body).to include('<a href="/albums/12"')
      expect(response.body).to include('<a href="/albums/6"')
    end
  end

  context "GET /add_artist" do
    it "Displays a form to add an artist" do
      response = get('/add_artist')
      expect(response.status).to eq (200)
      expect(response.body).to include ('<form method="POST" action="/add_artist">')
      expect(response.body).to include ('<input type="text" name="name" />')
      expect(response.body).to include ('<input type="text" name="genre" />')
    end
  end


  context "POST /add_artist" do
    it "Adds Curtis Mayfield artist to the database" do
      response = post('/add_artist', name: 'Curtis Mayfield', genre: 'Soul')
      expect(response.status).to eq (200)
      expect(response.body).to include ('<h1>You added Curtis Mayfield</h1>')
      expect(response.body).to include ('<h2>Genre: Soul</h2>')
      response = get('/artists')
      expect(response.status).to eq(200)
      expect(response.body).to include('<a href="/artists/5">Curtis Mayfield</a>')

    end

    it "Adds Outkast artist to the database" do
      response = post('/add_artist', name: 'Outkast', genre: 'Hip-hop')
      expect(response.status).to eq (200)
      expect(response.body).to include ('<h1>You added Outkast</h1>')
      expect(response.body).to include ('<h2>Genre: Hip-hop</h2>')
      response = get('/artists')
      expect(response.status).to eq(200)
      expect(response.body).to include('<a href="/artists/5">Outkast</a>')
    end
  end

  context "GET /add_album" do
    it "Displays a form to add an album" do
      response = get('/add_album')
      expect(response.status).to eq (200)
      expect(response.body).to include ('<form method="POST" action="/add_album">')
      expect(response.body).to include ('<input type="text" name="title" />')
      expect(response.body).to include ('<input type="text" name="artist_id" />')
    end
  end

  context "POST /add_album" do
    it "Adds Voulez-vous album to the database" do
      response = post('/add_album', title: 'Voulez-vous', release_year: 1972, artist_id: 2)
      expect(response.status).to eq (200)
      expect(response.body).to include ('<h1>You added Voulez-vous</h1>')
      expect(response.body).to include ('<h2>Release year: 1972</h2>')
      response = get('/albums')
      expect(response.status).to eq(200)
      expect(response.body).to include('Title: Voulez-vous')
      expect(response.body).to include('<a href="/albums/13">')
      expect(response.body).to include('Released: 1972')


    end

    it "Adds Doggerel album to the database" do
      response = post('/add_album', title: 'Doggerel', release_year: 2022, artist_id: 1)
      expect(response.status).to eq (200)
      expect(response.body).to include ('<h1>You added Doggerel</h1>')
      expect(response.body).to include ('<h2>Release year: 2022</h2>')
      response = get('/albums')
      expect(response.body).to include('Title: Doggerel')
      expect(response.body).to include('<a href="/albums/13">')
      expect(response.body).to include('Released: 2022')
    end
  end
end
