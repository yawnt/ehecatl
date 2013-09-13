local awful = require('awful')
local mocp = {}

function mocp:playing()
  return mocp:format() ~= ' - ' and mocp:format() ~= ''
end

function mocp:format()
  local pipe = io.popen('mocp -Q "%artist - %song" 2> /dev/null')
  local f = pipe:read('*all')

  pipe:close()

  return f:gsub("\n", "")
end

return mocp
