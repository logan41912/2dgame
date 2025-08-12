-- gui.lua

local gui = {}
local button = { x = 220, y = 320, w = 200, h = 50 }

function gui.draw(score)
    -- Overlay
    love.graphics.setColor(0, 0, 0, 0.6)
    love.graphics.rectangle("fill", 0, 0, 640, 640)

    -- Text
    love.graphics.setColor(1, 1, 1)
    love.graphics.printf("Game Over", 0, 200, 640, "center")
    love.graphics.printf("Score: " .. score, 0, 240, 640, "center")

    -- Restart button
    love.graphics.setColor(0.3, 0.9, 0.3)
    love.graphics.rectangle("fill", button.x, button.y, button.w, button.h)
    love.graphics.setColor(0, 0, 0)
    love.graphics.printf("Restart", button.x, button.y + 15, button.w, "center")
end

function gui.update(dt)
    -- Optional GUI logic
end

function gui.mousepressed(x, y, onClick)
    if x > button.x and x < button.x + button.w and
       y > button.y and y < button.y + button.h then
        onClick()
    end
end

return gui
