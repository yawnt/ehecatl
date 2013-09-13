local awful = require('awful')
local naughty = require("naughty")

local function jumpto(clientname)
  local function filter(c)
    return awful.rules.match(c, {class = clientname})
  end

  for c in awful.client.iterate(filter) do
    awful.client.jumpto(c)
  end
end

-- Adds some utility functions to fixed layouts
-- From layout.fixed source:
-- http://git.naquadah.org/?p=awesome.git;a=blob;f=lib/wibox/layout/fixed.lua.in;h=ef800b452e169ad7197102bba5ce18dd156c5942;hb=HEAD
local function layoutpatch(fixed)
  -- adds a widget to start
  function fixed:unshift(widget)
    table.insert(self.widgets, 1, widget)
    widget:connect_signal("widget::updated", self._emit_updated)
    self._emit_updated()
  end

  -- removes first widget
  function fixed:shift()
    table.remove(self.widgets, 1)
    self._emit_updated()
  end
end

return {
  jumpto = jumpto,
  layoutpatch = layoutpatch
}
