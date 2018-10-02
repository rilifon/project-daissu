local ELEMENT = require "classes.primitives.element"
local Class   = require "extra_libs.hump.class"

local funcs = {}

--CLASS DEFINITION--

local DieSlot = Class{
    __includes={ELEMENT}
}

function DieSlot:init()
    ELEMENT.init(self)
    self.die = false --Which die is on this slot. False if none.
end

--CLASS FUNCTIONS--

--Put a die in this slot, remove previous die and update position
function DieSlot:putDie(die)
    if self.die then self:removeDie() end
    self.die = die
    assert(not die.slot)
    self.die.slot = self
    local die_view = self.die.view
    die_view.pos.x = self.view.pos.x + self.view.margin
    die_view.pos.y = self.view.pos.y + self.view.margin
end

function DieSlot:removeDie()
    self.die.slot = nil
    self.die = nil
end

function DieSlot:getDie()
    return self.die
end

return DieSlot
