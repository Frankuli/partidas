require 'sinatra'#1.4.8
require 'data_mapper'

DataMapper.setup(:default, 'sqlite:db/development.db')
DataMapper::Logger.new($stdout, :debug)

class Partida
	include DataMapper::Resource
	property :id, Serial
	property :fecha, Date
	property :descripcion, String
	property :posicion, Integer
	property :puntaje, Integer
	property :kills, Integer
	property :duracion, Integer
	property :fecha, Date 
	
	has n, :comentarios

end

class Comentario 
	include DataMapper::Resource
	property :id, Serial
	property :texto, String
	property :fecha, Date
	
	belongs_to :partida
end

Partida.auto_upgrade!
Comentario.auto_upgrade!

DataMapper.finalize

get '/' do
	@partidas = Partida.all
	p "-------------"
	p @partidas
	haml :index
end

get '/nueva_partida' do
	haml :nueva_partida
end

get "/detalle/:id" do	
	@una_nueva = Partida.get(params[:id])
	haml :detalle
end

post '/crear_comentario/:partida_id' do
	partida = Partida.get(params[:partida_id])
	comentario = Comentario.new
	comentario.texto = params[:texto]
	partida.comentarios << comentario	
	partida.save
	redirect "/detalle/#{partida.id}"
end

post '/crear' do
	match = Partida.new
	match.posicion = params[:posicion]
	match.descripcion = params[:descripcion]
	match.kills = params[:kills]
	match.puntaje = params[:puntaje]
	match.duracion = params[:duracion]
	match.save
	p match
	p Partida.all
	redirect "/"
end

get '/delete/:id' do
	@delete = Partida.get(params[:id])
	@delete.destroy
	redirect "/"
end

get "/update/:id" do
	@update= Partida.get(params[:id])
	haml :update
end
post "/update/:id" do
	@update= Partida.get(params[:id])
	@update.posicion = params[:posicion]
	@update.descripcion = params[:descripcion]
	@update.kills = params[:kills]
	@update.puntaje = params[:puntaje]
	@update.duracion = params[:duracion]
	@update.save
	redirect "/detalle/#{@update.id}"
end