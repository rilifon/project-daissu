local Class = require "common.extra_libs.hump.class"
local Client = require "classes.net.client"

--[[
    A Controller is a class that handles the actions of a player. It keeps a Player object and moves it around the map.
]]

local Controller = Class {}

-- Start controller with a player on map on position pos
function Controller:init(map, player, source)
    self.map = map
    self.source = source
    self.player = player
end

function Controller:getPosition()
    return self.player.model.tile:getPosition()
end

function Controller:waitForInput(match, input_handler, callback)
    if self.source == 'local' then
        input_handler.chosen_input = function(self, ...)
            Client.send('action input', {input_handler:processInput(...)})
            callback(input_handler:processInput(...))
        end
        match.action_input_handler = input_handler
    elseif self.source == 'remote' then
        Client.listenOnce('action input', function(data)
            callback(unpack(data))
        end)
    end
end

function Controller:getSource()
    return self.source
end

return Controller
