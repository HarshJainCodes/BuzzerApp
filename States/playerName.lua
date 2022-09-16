PlayerName = Class{__includes = BaseState}

function PlayerName:init()
    self.textbox = {}
    self.textbox.width = 200
    self.textbox.height = 40
    self.textbox.x = WINDOW_WIDTH /2 - self.textbox.width/2
    self.textbox.y = WINDOW_HEIGHT/3 - self.textbox.height/2
    self.textbox.text = ""

    self.font = love.graphics.newFont(20)

    self.joinButton = {}
    self.joinButton.width = 200
    self.joinButton.height = 40
    self.joinButton.x = WINDOW_WIDTH / 2 - self.joinButton.width / 2
    self.joinButton.y = WINDOW_HEIGHT/3 - self.joinButton.height / 2 + WINDOW_HEIGHT/10
end

function PlayerName:textinput(t)
    self.textbox.text = self.textbox.text..t 
end

function PlayerName:keypressed(key)
    if key == "backspace" then
        local byteoffset = utf.offset(self.textbox.text, -1)
        if byteoffset then
            self.textbox.text = string.sub(self.textbox.text, 1, byteoffset - 1)
        end
    end
end

function PlayerName:mousepressed(x, y)
    if x > self.joinButton.x and x < self.joinButton.x + self.joinButton.width and y > self.joinButton.y and y < self.joinButton.y + self.joinButton.height then
        gStateMachine:change("playerState", self.textbox.text)
    end
end

function PlayerName:update(dt)
    
end

function PlayerName:render()
    love.keyboard.setTextInput(true)
    love.graphics.setFont(self.font)
    love.graphics.printf("enter your team name", 0, WINDOW_HEIGHT / 4, WINDOW_WIDTH, "center")

    love.graphics.rectangle("line", self.textbox.x, self.textbox.y, self.textbox.width, self.textbox.height)
    love.graphics.printf(self.textbox.text, self.textbox.x, self.textbox.y + 10, self.textbox.width, "center")

    love.graphics.printf("Join", self.joinButton.x, self.joinButton.y, self.joinButton.width, "center")
    love.graphics.rectangle("line", self.joinButton.x, self.joinButton.y, self.joinButton.width, self.joinButton.height)
end