PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.title = "Welcome to the Buzzer App"
    self.font = love.graphics.newFont(20)

    self.managerButton = {x = WINDOW_WIDTH / 2 - 100, y = WINDOW_HEIGHT / 2 - 10, width = 200, height = 20, text = "Manager"}
    self.playerButton = {x = WINDOW_WIDTH / 2 - 100, y = WINDOW_HEIGHT / 2 - 10 + 50, width = 200, height = 20, text = "Player"}
end

function PlayState:update(dt)
    
end

function PlayState:render()
    love.graphics.setFont(self.font)
    love.graphics.printf("who are you?", 9, WINDOW_HEIGHT/4 + 130, WINDOW_WIDTH, "center")
    love.graphics.printf(self.title, 0, WINDOW_HEIGHT/4, WINDOW_WIDTH, "center")
    love.graphics.printf(self.managerButton.text, self.managerButton.x, self.managerButton.y, self.managerButton.width, "center")
    love.graphics.rectangle("line", self.managerButton.x, self.managerButton.y, self.managerButton.width, self.managerButton.height)

    love.graphics.printf(self.playerButton.text, self.playerButton.x, self.playerButton.y, self.playerButton.width, "center")
    love.graphics.rectangle("line", self.playerButton.x, self.playerButton.y, self.playerButton.width, self.playerButton.height)
end

function PlayState:keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

function PlayState:mousepressed(x, y)
    if x > self.managerButton.x and x < self.managerButton.x + self.managerButton.width and y > self.managerButton.y and y < self.managerButton.y + self.managerButton.height then
        gStateMachine:change('managerState')
    elseif x > self.playerButton.x and x < self.playerButton.x + self.playerButton.width and y > self.playerButton.y and y < self.playerButton.y + self.playerButton.height then
        gStateMachine:change('playerName')
    end
end

function PlayState:enter()
end

function PlayState:exit()
    
end