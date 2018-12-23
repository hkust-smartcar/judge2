require 'imba-router'
var io = require 'socket.io-client'
var socket = io process:config.HOST
import {store} from './lib/store'
# store:socket = socket
import {Index} from './page/index'
import {Profile} from './page/profile'
import {Submit} from './page/submit'
import {NavBar} from './components/nav-bar'
# import {ScoreBoard} from './page/score-board'

if process:config.MODE === 'dev'
	console.log 'development mode is on'
	console.log process:config
	socket.on 'reload' do |data|
		console.log 'hot reloading...'
		console.log data
		Imba.setTimeout(1000) do
			window:location.reload

tag App		
	def render
		return
			<self>
				<NavBar>
				<a route-to='/'> "Home"
				<a route-to='/profile'> "profile"
				<a route-to='/submit'> "submit"
				<Index route='/'> 
				<Profile route='/profile'>
				<Submit route='/submit'>

store:user = window:user
store:page = window:page || '/'

console.log window:user
socket.on 'name' do |data|
	console.log data
socket.on 'alert' do |data|
	console.log data

Imba.mount <App>
