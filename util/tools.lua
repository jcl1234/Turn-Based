--Line
line = {}
line.orig = love.graphics.getLineWidth()
function line.set(width)
	love.graphics.setLineWidth(width)
end

function line.pop()
	love.graphics.setLineWidth(line.orig)
end
