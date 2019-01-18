local Textbox = class{
	textboxes = {},
	selected = {},
	init = function(self, x, y, width, height)
		self.x = x
		self.y = y
		self.width = width
		self.height = height

		self.color = ui.colors.blue
		self.border = true
		self.borderColor = ui.colors.red
		self.borderWidth = 3

		self.round = 0


		self.text = ""
		self.textColor = ui.colors.white
		self.textX = self.x
		self.textY = self.y

		self.maxLen = 0

		self.align = "left"

		self.active = true

		self.flashing = false
		self.flashColor = ui.colors.grey
		self.lastFlash = 0
		self.flashTime = .5

		self.unselectOnEnter = true
		self.removeOnEnter = true

		--Create button
		self.button = ui.Button:new(self.x, self.y, self.width, self.height, false)
		self.button.round = 0
		function self.button.onClick()
			if self.active then
				self.selected.sel = self
			end
		end

		table.insert(self.textboxes, self)
	end,

	setText = function(self, text)
		self.text = text
		local font = love.graphics.getFont()
		local width = font:getWidth(self.text)
		local height = font:getHeight(self.text)
		self.textY = (self.y + self.height/2) - height/2

		if self.align == "right" then
			self.textX = (self.x + self.width) - width
		elseif self.align == "left" then
			self.textX = self.x
			if width > self.width then
				self.textX = self.x - (width - self.width)
			end
		end
	end,

	remove = function(self)
		self.button:remove()
		for k, v in pairs(self.textboxes) do
			if v == self then
				table.remove(self.textboxes, k)
			end
		end
		if self.selected.sel == self then self.selected.sel = nil end
	end,

	--Hooks
	onEnter = function(self, text)
	end,

	--CLASSMETHODS
	textinput = function(cls, t)
		local tb = cls.selected.sel
		if tb then
			if #tb.text < tb.maxLen or tb.maxLen == 0 then
				tb:setText(tb.text..t)
			end
		end
	end,

	keypressed = function(cls, key)
		local tb = cls.selected.sel
		if tb then
			if key == "escape" then
				tb.flashing = false
				cls.selected.sel = nil
			elseif key == "backspace" then
				local len = #tb.text
				if len >= 1 then
					tb:setText(string.sub(tb.text, 1, len - 1))
				end
			elseif key == "return" then
				if #tb.text >= 1 then
					if tb.onEnter then
						tb:onEnter(tb.text)
					end
					if tb.removeOnEnter then
						tb:setText("")
					end

					if tb.unselectOnEnter then
						cls.selected.sel = nil
					end
				end
			end
		end
	end,

	update = function(cls, dt)
		local tb = cls.selected.sel
		if tb then
			tb.lastFlash = tb.lastFlash + dt
			if tb.lastFlash >= tb.flashTime then
				tb.flashing = not tb.flashing
				tb.lastFlash = 0
			end
		end
	end,

	draw = function(cls)
		for k, tb in pairs(cls.textboxes) do
			--Border
			if tb.border then
				line.set(tb.borderWidth)
				love.graphics.setColor(tb.borderColor)
				love.graphics.rectangle("line", tb.x, tb.y, tb.width, tb.height, tb.round, tb.round)
				line.pop()
			end
			---
			love.graphics.setScissor(tb.x, tb.y, tb.width, tb.height)
			-------
			--Background
			love.graphics.setColor(tb.color)
			love.graphics.rectangle("fill", tb.x, tb.y, tb.width, tb.height)
			--Text
			love.graphics.setColor(tb.textColor)
			love.graphics.print(tb.text, tb.textX, tb.textY)
			--Flashing
			if tb.flashColor and tb.flashing then
				if tb.flashing then
					line.set(4)
					love.graphics.setColor(tb.flashColor)
					love.graphics.rectangle("line", tb.x, tb.y, tb.width, tb.height)
					line.pop()
				end
			end
			-------
			love.graphics.setScissor()
			---
		end
	end,
}

return Textbox