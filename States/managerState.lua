ManagerState = Class{__includes = BaseState}

function ManagerState:init()
    love.window.setVSync(0) -- enable if you want unrestricted frame rate

    ipAddress = socket.dns.toip(socket.dns.gethostname())
    self.server = sock.newServer(ipAddress, 8000)
    -- self.server = sock.newServer("192.168.1.255", 8000)
    self.server:setSerialization(bitser.dumps, bitser.loads)


    self.clients = {}   -- this table will store all the client objects
    self.buzzzerRequest = {}    -- this will store who pressed the buzzer first in case of many people 
                                -- people pressing the buzzer at the same time.

    self.resetButton = {x = WINDOW_WIDTH / 2 - 100, y = 3 * WINDOW_HEIGHT / 4 - 25, width = 200, height = 50}   -- resets the buzzer

    self.server:on("connect", function (data, client)
        table.insert(self.clients, {client, "", 0})
        client:send("connected", "you are connected")
        print("client connected")
    end)

    self.server:on("buttonPressed", function (data, client)
        if (#self.buzzzerRequest == 0) then -- checks if you are the first one to press the buzzer.
            table.insert(self.buzzzerRequest, client)
            for key, value in pairs(self.clients) do
                if value[1] == client then
                    value[3] = 1
                end
            end
            client:send("success", {1, 0, 0})
        end
    end)

    -- get the name of the client as soon as they connect
    -- we are storing the actual client object created on the client side so we can update the empty string in the self.clients table
    -- refer to the on:connect function we paas {client, name, something} to the self.clients table
    self.server:on("teamName", function (data, client)
        for key, value in pairs(self.clients) do
            if value[1] == client then
                print("client matched")
                value[2] = data
                print(value[2])
            end
        end
    end)

    -- constantly ping the server cuz if a client disconnects then it will not show on the server side until
    -- a new request is send from the client side so we send a empty ping
    self.server:on("emptyping", function (data, client)
        
    end)
end

function ManagerState:update(dt)
    self.server:update()

    -- remove any player that leaves the game / buzzer room
    for key, client in pairs(self.clients) do
        if client[1]:getState() == "disconnected" then
            table.remove(self.clients, key)
        end
    end

    print(self.server:getTotalReceivedData())
end

function ManagerState:render()
    --localip = socket.dns.toip(socket.dns.gethostname())
    --love.graphics.print(localip)



    love.graphics.printf(tostring(#self.buzzzerRequest), 0, 100, 100, "center")
    love.graphics.printf(self.server:getAddress(), 0, 0, WINDOW_WIDTH, "center")

    love.graphics.printf("reset", self.resetButton.x, self.resetButton.y, self.resetButton.width, "center")
    love.graphics.rectangle("line", self.resetButton.x, self.resetButton.y, self.resetButton.width, self.resetButton.height)

    yIndex = 1
    -- print all the people connected to the server in a table form
    for key, value in pairs(self.clients) do
        love.graphics.printf(value[2], 0, 200 * yIndex, WINDOW_WIDTH, "center")
        if value[3] == 0 then
            love.graphics.setColor(1, 0, 0)
        elseif value[3] == 1 then
            love.graphics.setColor(0, 1, 0)
        end
        
        love.graphics.rectangle("fill", WINDOW_WIDTH /2 + 100, 200 * yIndex, 20, 20)
        love.graphics.setColor(1, 1, 1)
        yIndex = yIndex + 0.2
    end
end

function ManagerState:mousepressed(x, y)
    if x > self.resetButton.x and x < self.resetButton.x + self.resetButton.width and y > self.resetButton.y and y < self.resetButton.y + self.resetButton.height then
        self.buzzzerRequest = {}
        self.server:sendToAll("resetColor", {1, 1, 1})
        for key, value in pairs(self.clients) do
            value[3] = 0
        end
    end
end