WINDOW_WIDTH = 400
WINDOW_HEIGHT = 700

push = require 'push'
bitser = require "bitser"
sock = require "sock"
utf = require "utf8"
socket = require "socket"

Class = require 'class'

require 'StateMachine'
require 'States.BaseState'
require 'States.playerState'
require "States.playerName"
require 'States.managerState'
require 'States/PlayState'


function love.load()
    push:setupScreen(WINDOW_WIDTH, WINDOW_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false;
        vsync = true;
        resizable = true;
        stretched = false;
    })

    love.window.setTitle("My Buzzer")

    love.graphics.setDefaultFilter("nearest", "nearest")

    gStateMachine = StateMachine{
        ['play'] = function () return PlayState() end,
        ['playerState'] = function () return PlayerState() end,
        ['managerState'] = function () return ManagerState() end,
        ['playerName'] = function () return PlayerName() end
    }
    gStateMachine:change('play')

    
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.update(dt)
    gStateMachine:update(dt)
end

function love.keypressed(key)
    gStateMachine.current:keypressed(key)
end

function love.mousepressed(x1, y1)
    x, y = push:toGame(x1, y1)
    if x ~= nil and y ~= nil then
        gStateMachine.current:mousepressed(x, y) 
    end
end

function love.textinput(t)
    gStateMachine.current:textinput(t)
end

function love.draw()
    push:start()
    --love.graphics.clear(1, 0, 1)
    gStateMachine:render()
    --love.graphics.print(collectgarbage('count'))

    --love.graphics.printf("fps = "..love.timer.getFPS(), 0, 0, WINDOW_WIDTH, "center")
    push:finish()
end