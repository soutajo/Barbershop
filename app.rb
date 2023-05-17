#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'

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

	erb "OK, you choose: #{@username}, #{@phone}, #{@date_time}, #{@barber}, #{@color}"
end