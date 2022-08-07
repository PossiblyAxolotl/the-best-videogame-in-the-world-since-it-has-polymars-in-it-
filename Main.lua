-- PossiblyAxolotl
-- Created August 7th, 2022
-- Stream Game

import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "COreLibs/math"

math.randomseed(playdate.getSecondsSinceEpoch())

local gfx <const> = playdate.graphics
local disp <const> = playdate.display

local imgBall = gfx.image.new("gfx/ball")
local sprBall = gfx.sprite.new(imgBall)
sprBall:moveTo(40,40)

local imgTiles = gfx.imagetable.new("gfx/tiles")

local tileMap = gfx.tilemap.new(imgTiles)
tileMap:setImageTable(imgTiles)

tileMap:setSize(25, 15)

sprBall:setCollideRect(7,7,8,8)
sprBall:add()

local vx, vy = 0, 0

for i = 1, (400/16), 1 do
    tileMap:setTileAtPosition(i,1,6)
    tileMap:setTileAtPosition(i,15,5)
end

for i = 1, (240/16), 1 do
    tileMap:setTileAtPosition(1,i,3)
    tileMap:setTileAtPosition(25,i-3,4)
end

tileMap:setTileAtPosition(1,1,2)
tileMap:setTileAtPosition(1,15,2)
tileMap:setTileAtPosition(25,1,2)
tileMap:setTileAtPosition(25,15,2)

local level = json.decodeFile("level.json")

for i = 1, #level.tiles, 1 do
    tileMap:setTileAtPosition(level.tiles[i].x,level.tiles[i].y,math.random(7,8))
end

gfx.sprite.addWallSprites(tileMap, {1})

local function detectCollisions()
    -- x collision
    sprBall:moveBy(5,0)
    if #sprBall:overlappingSprites() > 0 then
        vx *= -1
    end

    sprBall:moveBy(-10,0)
    if #sprBall:overlappingSprites() > 0 then
        vx *= -1
    end

    sprBall:moveBy(5,0)

    -- y collision 
    sprBall:moveBy(0,5)
    if #sprBall:overlappingSprites() > 0 then
        vy *= -1
    end

    sprBall:moveBy(0,-10)
    if #sprBall:overlappingSprites() > 0 then
        vy *= -1
    end

    sprBall:moveBy(0,5)
end

function playdate.update()
    gfx.clear()

    if vx <= 0.1 and vx >= -0.1 and vy <= 0.1 and vy >= -0.1 then
        local dir = playdate.getCrankPosition()
        local dirTable = {x = math.sin(math.rad(dir)), y = -math.cos(math.rad(dir))}

        if playdate.buttonJustPressed(playdate.kButtonA) then
            vx, vy = dirTable.x * 10, dirTable.y * 10
        end
    end

    detectCollisions()

    vx, vy = playdate.math.lerp(vx, 0, 0.1), playdate.math.lerp(vy, 0, 0.1)

    sprBall:moveBy(vx,vy)

    gfx.sprite.update()

    tileMap:draw(0,0)

    gfx.drawCircleAtPoint(200,120,10)
end