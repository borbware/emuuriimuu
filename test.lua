-- INCLUDE THE CURRENT PATH FOR LUA AND REQUIRE THE LIB --
-- DO NOT CHANGE THAT PART --
package.path = package.path .. ";" .. "..\\?.lua"
require "svg-min"
require "runes"
-- END OF LIBRARY IMPORT --

-- TEST IS STARTING HERE -- YOU CAN MODIFY IT --

local runetext="e-muu-rom"

runes = svg:create()
local scale=50
runes.width=printrunes(runes,runetext,10,10,"#000000",scale,1,false,0)+scale
runes.height=scale*3
print(runes:draw())