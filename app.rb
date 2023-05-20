#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def if_barber_exists? db, name
	db.execute('SELECT * FROM Barbers WHERE name=?;', [name]).length > 0
end

def seed_db db, barbers
	barbers.each do |barber|
		if !if_barber_exists? db, barber
			db.execute 'INSERT INTO Barbers (name) VALUES (?)', [barber]
		end
	end
end

def get_db
	db = SQLite3::Database.new 'barbershop.db'
	db.results_as_hash = true
	return db
end

before do
	db = get_db
	@barbers = db.execute 'SELECT * FROM Barbers'
end

configure do
	db = get_db
	db.execute 'CREATE TABLE IF NOT EXISTS 
	  "Users" 
	  (
		  "id" INTEGER PRIMARY KEY AUTOINCREMENT, 
		  "username" TEXT, 
		  "phone" TEXT, 
		  "datestamp" TEXT, 
			"barber" TEXT, 
		  "color" TEXT
	  );'

		db.execute 'CREATE TABLE IF NOT EXISTS 
	  "Barbers" 
	  (
		  "id" INTEGER PRIMARY KEY AUTOINCREMENT, 
		  "name" TEXT
	  );'

		seed_db db, ['Jessie Pinkman', 'Walter White', 'Gus Fring', 'Mike Ehrmantraut']
end

get '/' do
	erb "Welome to our Barber Shop!"			
end

get '/about' do
	erb :about
end

get '/contacts' do
	erb :contacts
end

get '/visit' do
	erb :visit
end

post '/visit' do

	@username = params[:username]
	@phone = params[:phone]
	@date_time = params[:date_time]
	@barber = params[:barber]
	@color = params[:color]	

	if @username == ''
		@error = 'Enter your name'
	end

	hh = { :username => 'Enter your name',
		     :phone => 'Enter your phone', 
				 :date_time => 'Enter date and time'
				}

	@error = hh.select {|key,_| params[key] == ""}.values.join(', ')

	if @error != ''
		return erb :visit
	end
  db = get_db
	db.execute 'INSERT INTO users (username, phone, datestamp, barber, color) VALUES (?, ?, ?, ?, ?)', [@username, @phone, @date_time, @barber, @color]

	erb "OK, you choose: #{@username}, #{@phone}, #{@date_time}, #{@barber}, #{@color}"
end

get '/showusers' do
	db = get_db

	@results = db.execute 'SELECT * FROM Users ORDER BY id DESC'

	erb :showusers
end
