PlayerState = Class{__includes = BaseState}

function PlayerState:enter(teamName)
    self.teamName = teamName
end

function PlayerState:init()
    love.window.setVSync(0) -- to unlimit the frame rate

    -- make a test client
    -- I know my router gives ip from 192.168.0.0 to 192.168.0.255
    -- self.client = sock.newClient("192.168.0.0", 8000)
    self.client = sock.newClient("192.168.56.0", 8000)
    self.client:setSerialization(bitser.dumps, bitser.loads)
    self.client:connect()
    --print(self.client:getState())
    
    -- count is the 192.168.0.count ip that we are currently trying
    count = 0

    -- times tried is the number of times the self.client:update() is called
    -- self.client dosnt connect first time you call self.client:connet()
    -- it takes few updates (approx 4-5) to actually connect to the server
    timesTried = 0

    didWeConnect = false

    -- timer for sending an empty ping
    emptyPingingTimer = 0


    doitonce = true

    -- buzzer attributes
    self.connectionMessage = ""
    self.color = {1, 1, 1}
    self.buzzerSound = love.audio.newSource("buzzer_sound.wav", "stream")
    self.unpressed_img = love.graphics.newImage("unpressed_buzzer.png")
    self.pressed_img = love.graphics.newImage("pressed_buzzer.png")

    self.font = love.graphics.newFont(20)

    self.buzzerButton = {x = WINDOW_WIDTH / 2 - 100, y = 3 * WINDOW_HEIGHT / 4 - 25, width = 200, height = 50}
end

function PlayerState:update(dt)
    self.client:update()

    timesTried = timesTried + 1
    emptyPingingTimer = emptyPingingTimer + dt

    if self.client:getState() == "connected" then
        didWeConnect = true

        -- initialise the functions needed once we are connected to the server
        if doitonce then
            self.client:on("connected", function (data)
                self.connectionMessage = data
                self.client:send("teamName", self.teamName)
            end)
        
            self.client:on("success", function (data)
                self.color = data
                self.buzzerSound:play()
            end)
        
            self.client:on("resetColor", function (data)
                self.color = data
            end)
            doitonce = false
        end
        if emptyPingingTimer > 1 then
            self.client:send("emptyping", 0)
            emptyPingingTimer = 0
        end
    end

    if self.client:getState() == "connected" then
        print("connected to " .. self.client:getAddress())
    else
        print("connecting ip" .. count)
    end
    

    -- we need few updates to actually connect to the server so try for 
    -- say 10 updates if we dont connect then increase the count value
    if timesTried == 10 and not didWeConnect then
        count = count + 1

        -- replace our client with the new created client
        -- self.client = sock.newClient("192.168.0." .. tostring(count), 8000)
        self.client = sock.newClient("192.168.56." .. tostring(count), 8000)
        self.client:connect()

        -- open the debug window to see this message
        timesTried = 0
    end

    -- if not didWeConnect then
    --     for count = 1, 255 do
    --         if didWeConnect then
    --             break
    --         end
    --         self.client = sock.newClient("192.168.0." .. tostring(count), 8000)
    --         self.client:connect()

    --         for i = 1, 10 do
    --             self.client:update()
    --             if self.client:getState() == "connected" then
    --                 didWeConnect = true
    --             end
    --             self.client:getAddress()
    --             print("trying on address" .. self.client:getAddress())
    --         end
    --     end
    -- end
end


function PlayerState:mousepressed(x, y)
    if x > self.buzzerButton.x and x < self.buzzerButton.x + self.buzzerButton.width and y > self.buzzerButton.y and y < self.buzzerButton.y + self.buzzerButton.height then
        self.client:send("buttonPressed", 0)
    end
end

function PlayerState:render()
    if self.client:getState() ~= "connected" then
        love.graphics.printf("connecting to the host please wait..", 0, 200, WINDOW_WIDTH, "center")
        love.graphics.printf("trying on " .. count, 0, 250, WINDOW_WIDTH, "center")
    end
    localip = socket.dns.toip(socket.dns.gethostname())
    love.graphics.print(localip)
    love.keyboard.setTextInput(false)
    love.graphics.setFont(self.font)
    love.graphics.printf(self.teamName, 0, 100, WINDOW_WIDTH, "center")

    love.graphics.printf(self.connectionMessage, 0, 0, WINDOW_WIDTH, "center")
    love.graphics.printf("buzzer", self.buzzerButton.x, self.buzzerButton.y, self.buzzerButton.width, "center")
    love.graphics.setColor(self.color)

    if self.color[2] == 1 then
        love.graphics.draw(self.unpressed_img, WINDOW_WIDTH / 2 - 50, WINDOW_HEIGHT / 2 - 50, 0, 100/self.unpressed_img:getWidth(), 100/self.unpressed_img:getHeight())
    else
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(self.pressed_img, WINDOW_WIDTH/2 - 50, WINDOW_HEIGHT/2 - 50, 0, 100 /self.pressed_img:getWidth(), 100/self.pressed_img:getHeight())
    end
    love.graphics.rectangle("line", self.buzzerButton.x, self.buzzerButton.y, self.buzzerButton.width, self.buzzerButton.height)
end