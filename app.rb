#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def get_db
	return SQLite3::Database.new 'barbershop.db'
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
				 :date_time => 'Enter date and time',
				 :username => 'Enter your name'	}

	@error = hh.select {|key,_| params[key] == ""}.values.join(', ')

	if @error != ''
		return erb :visit
	end
  db = get_db
	db.execute 'INSERT INTO users (username, phone, datestamp, barber, color) VALUES (?, ?, ?, ?, ?)', [@username, @phone, @date_time, @barber, @color]

	erb "OK, you choose: #{@username}, #{@phone}, #{@date_time}, #{@barber}, #{@color}"
end
