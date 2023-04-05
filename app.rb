# file: app.rb
require 'sinatra'
require "sinatra/reloader"
require_relative './lib/database_connection'
require_relative './lib/album_repository'
require_relative './lib/artist_repository'

DatabaseConnection.connect

class Application < Sinatra::Base
  configure :development do
    register Sinatra::Reloader
    also_reload 'lib/album_repository'
    also_reload 'lib/artist_repository'
  end

  get '/albums' do
    repo = AlbumRepository.new
    @albums = repo.all

    return erb(:albums)
  end

  get '/albums/:id' do
    id = params[:id]
    # return "The id is #{id}"
    album_repo = AlbumRepository.new
    @album = album_repo.find(id)
    # return "The album title is #{@album.title}"
    artist_repo = ArtistRepository.new
    @artist = artist_repo.find(@album.artist_id)
    return erb(:album )
  end

  post '/albums' do
    album = Album.new
    album.title = params[:title]
    album.release_year = params[:release_year]
    album.artist_id = params[:artist_id]
    repo = AlbumRepository.new
    repo.create(album)
  end

  get '/artists' do
    repo = ArtistRepository.new
    @artists = repo.all
    return erb(:artists)
  end

  get '/artists/:id' do
    repo = ArtistRepository.new
    @artist = repo.find(params[:id])
    return erb(:artist)
  end

  post '/artists' do
    artist = Artist.new
    artist.name = params[:name]
    artist.genre = params[:genre]
    repo = ArtistRepository.new
    repo.create(artist)
  end

  get '/add_artist' do
    return erb(:add_artist)
  end

  post '/add_artist' do
    @artist = Artist.new
    @artist.name = params[:name]
    @artist.genre = params[:genre]
    repo = ArtistRepository.new
    repo.create(@artist)
    puts "Added artist!" # Testing that these messages are printed to terminal screen in rackup logs
    return erb(:confirm_add_artist)
  end

  get '/add_album' do
    return erb(:add_album)
  end

  post '/add_album' do
    @album = Album.new
    @album.title = params[:title]
    @album.release_year = params[:release_year]
    @album.artist_id = params[:artist_id]
    repo = AlbumRepository.new
    repo.create(@album)
    return erb(:confirm_add_album)
  end
end