local gui = require("gui")

-- Player setup
local player = { x = 300, y = 500, w = 40, h = 40, speed = 300, health = 100 }

-- Bullets
local bullets = {}

-- Enemies
local enemies = {}
local enemySpawnTimer = 0

-- Score
local score = 0
local gameOver = false

function love.load()
    love.window.setTitle("TopDown Blaster")
    love.window.setMode(640, 640)
end

function love.update(dt)
    if gameOver then
        gui.update(dt)
        return
    end

    -- Player movement
    if love.keyboard.isDown("left") then player.x = player.x - player.speed * dt end
    if love.keyboard.isDown("right") then player.x = player.x + player.speed * dt end
    if love.keyboard.isDown("up") then player.y = player.y - player.speed * dt end
    if love.keyboard.isDown("down") then player.y = player.y + player.speed * dt end

    -- Clamp player to screen
    player.x = math.max(0, math.min(player.x, 640 - player.w))
    player.y = math.max(0, math.min(player.y, 640 - player.h))

    -- Shooting bullets
    if love.keyboard.isDown("space") then
        if not player.lastShot or love.timer.getTime() - player.lastShot > 0.2 then
            table.insert(bullets, { x = player.x + player.w/2 - 4, y = player.y, w = 8, h = 16, speed = 500 })
            player.lastShot = love.timer.getTime()
        end
    end

    -- Update bullets
    for i = #bullets, 1, -1 do
        local b = bullets[i]
        b.y = b.y - b.speed * dt
        if b.y < -b.h then table.remove(bullets, i) end
    end

    -- Spawn enemies
    enemySpawnTimer = enemySpawnTimer - dt
    if enemySpawnTimer <= 0 then
        table.insert(enemies, { x = math.random(0, 600), y = -40, w = 40, h = 40, speed = 100 })
        enemySpawnTimer = 1
    end

    -- Update enemies
    for i = #enemies, 1, -1 do
        local e = enemies[i]
        e.y = e.y + e.speed * dt

        -- Check collision with player
        if checkCollision(player, e) then
            player.health = player.health - 20
            table.remove(enemies, i)
            if player.health <= 0 then
                gameOver = true
            end
        end

        -- Check collision with bullets
        for j = #bullets, 1, -1 do
            local b = bullets[j]
            if checkCollision(b, e) then
                table.remove(bullets, j)
                table.remove(enemies, i)
                score = score + 1
                break
            end
        end
    end
end

function love.draw()
    -- Player
    love.graphics.setColor(0.2, 0.8, 1)
    love.graphics.rectangle("fill", player.x, player.y, player.w, player.h)

    -- Bullets
    love.graphics.setColor(1, 1, 0)
    for _, b in ipairs(bullets) do
        love.graphics.rectangle("fill", b.x, b.y, b.w, b.h)
    end

    -- Enemies
    love.graphics.setColor(1, 0.3, 0.3)
    for _, e in ipairs(enemies) do
        love.graphics.rectangle("fill", e.x, e.y, e.w, e.h)
    end

    -- GUI
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Health: " .. player.health, 10, 10)
    love.graphics.print("Score: " .. score, 10, 30)

    if gameOver then
        gui.draw(score)
    end
end

function love.mousepressed(x, y, button)
    if gameOver then
        gui.mousepressed(x, y, function()
            restartGame()
        end)
    end
end

function checkCollision(a, b)
    return a.x < b.x + b.w and b.x < a.x + a.w and a.y < b.y + b.h and b.y < a.y + a.h
end

function restartGame()
    player.x = 300
    player.y = 500
    player.health = 100
    bullets = {}
    enemies = {}
    score = 0
    gameOver = false
end
