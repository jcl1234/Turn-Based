local Log = class{
	init = function(self, logger, text)
		self.text = text
		self.logger = logger
		local font = love.graphics.getFont()
		self.height = font:getHeight(self.text)

		self.x = 0
		self.y = 0

		table.insert(self.logger.logs, self)
	end,

	remove = function(self)
		for k,v in pairs(self.logger.logs) do
			if v == self then
				table.remove(self.logger.logs, k)
			end
		end
	end,
}

local Logger = class{
	loggers = {},
	init = function(self, x, y, width, height)
		self.logs = {}
		self.x = x
		self.y = y
		self.width = width
		self.height = height

		self.color = ui.colors.grey

		self.border = true
		self.borderWidth = 5
		self.borderColor = ui.colors.red

		self.round = 5

		self.offset = 14

		table.insert(self.loggers, self)
	end,

	addLine = function(self, text, color)
		for k, log in pairs(self.logs) do
			log.y = log.y + self.offset
		end

		local log = Log:new(self, text)
		log.x = self.x + 3
		log.y = self.y
	end,

	remove = function(self)
		for k,v in pairs(self.loggers) do
			if v == self then
				table.remove(self.loggers, k)
			end
		end
	end,

	--CLASSMETHODS
	draw = function(cls)
		for k, logger in pairs(cls.loggers) do
			--Border
			if logger.border then
				line.set(logger.borderWidth)
				love.graphics.setColor(logger.borderColor)
				love.graphics.rectangle("line", logger.x, logger.y, logger.width, logger.height, logger.round, logger.round)
				line.pop()
			end
			--Start cutoff
			love.graphics.setScissor(logger.x, logger.y, logger.width, logger.height)
			----------------
			love.graphics.setColor(logger.color)
			love.graphics.rectangle("fill", logger.x, logger.y, logger.width, logger.height, logger.round, logger.round)
			--Draw logs
			love.graphics.setColor(ui.colors.white)
			for k, log in pairs(logger.logs) do
				love.graphics.print(log.text, log.x, log.y)
			end
			----------------
			love.graphics.setScissor()
		end
	end,

	update = function(cls, dt)
		for k, logger in pairs(cls.loggers) do
			--Remove lines if off logger
			for k, log in pairs(logger.logs) do
				if log.y > logger.y + logger.height + logger.offset then
					log:remove()
				end
			end
		end
	end,
}

--[[
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
]]

return Logger