Gamestate = require "hump.gamestate"
Timer = require "hump.timer"
Class = require "hump.class" --havnet used this yet lol

Flux = require "flux"	

Objects = require "objects"
Prefs = require "prefs"

TitleState = require "states.TitleState"

function love.load()
	--stuff
	Gamestate.registerEvents()
	Gamestate.switch(TitleState)
end

function love.update(dt)
	Timer.update(dt)
	Flux.update(dt)
end