local Class        = require "common.extra_libs.hump.class"
local Map          = require "common.map.map"
local Player       = require "common.map.player"
local Util         = require "common.util"
local ActionsModel = require "common.actions_model"

local BoardLogic = Class {}

local starting_positions = {
    nil,                             -- 1 player
    {{2,2},{4,4}},                   -- 2 players
    {{1,1},{3,3},{5,5}},             -- 3 players
    {{2,2},{4,4},{5,1},{1,5}},       -- 4 players
    {{1,1},{2,3},{3,5},{4,2},{5,4}}, -- 5 players
}

function BoardLogic:init(rows, columns, number_of_players)
    self.state = 'not started'
    self.n_players = number_of_players
    assert(self.n_players > 1)
    assert(self.n_players <= 5)
    self.map = Map(rows, columns)

    self.players = {}
    for i = 1, number_of_players do
        local pi, pj = unpack(starting_positions[number_of_players][i])
        self.players[i] = Player()
        self.map:get(pi, pj):setObj(self.players[i])
    end

    self.n_turns = 1
end

function BoardLogic:start()
    assert(self.state == 'not started')
    self.state = 'waiting for turn'
end

function BoardLogic:startNewTurn()
    assert(self.state == 'waiting for turn')
    self.state = 'choosing actions'
end

-- player_actions is a list of lists, the i-th with the actions of the i-th player
-- This yields when an action is executed, this way you can get the input and show the animation
-- When it is resumed, it actually executes the action (using the return parameters)
function BoardLogic:playTurnFromActions(player_actions)
    assert(self.state == 'choosing actions')
    self.state = 'playing turn'
    local size = math.max(unpack(Util.map(player_actions, function(list) return #list end)))
    local order = self:getOrder()
    for j = 1, size do
        for i = 1, self.n_players do
            local p_i = order[i]
            if player_actions[p_i][j] ~= 'none' then
                ActionsModel.applyAction(
                    player_actions[p_i][j],
                    self.map,
                    self.players[p_i],
                    coroutine.yield {
                        player = p_i,
                        action = player_actions[p_i][j]
                    }
                )
            else
                coroutine.yield { player = p_i, action = 'none' }
            end
        end
    end
    self.n_turns = self.n_turns + 1
    self.state = 'waiting for turn'
end

function BoardLogic:startingPlayer()
    return ((self.n_turns - 1) % self.n_players) + 1
end

function BoardLogic:getOrder()
    local st = self:startingPlayer()
    local order = {}
    for i = 1, self.n_players do
        order[i] = ((st + i - 2) % self.n_players) + 1
    end
    return order
end

return BoardLogic
