require 'class'
-----------------------
Logger = require 'logger'

function love.load()
	logger = Logger:new(10, 10, 200, 100)
	logger:addLine("hi")
end

function love.update(dt)
	Logger:update(dt)
end

function love.draw()
	Logger:draw()
end