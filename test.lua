package.path = package.path .. ";" .. "..\\?.lua"
require "svg-min"
require "runes"

---------------------- 
-- EDIT THESE LINES:
---------------------- 

local runetext="e-muu-rom"
-- runetext=[[e-rit-täen mui-nae-sen u-to-pian
-- us-seem-mi-ten raa-han-o-ma-siks
-- o-sot-taa-tun-neet me-täh-heŋ-ŋet
-- ]]
-- runetext="mui-nae-sen u-to-pian me-täh-heŋ-ŋet"

local padding={
    x=50,
    y=50,
}
local scale=50
local linespacing=scale
local centering=true
local strokewidth=7
local color="#000000"

---------------------- 
-- DON'T EDIT:
---------------------- 

local xoffset=0
if centering then--calculate offset
    local temprunes = svg:create()
    local width = printrunes(temprunes,runetext,padding.x,padding.y,color,scale,strokewidth,centering,scale*2+linespacing)
    xoffset=width/2
end

local runes = svg:create()
local width,lines = printrunes(runes,runetext,padding.x+xoffset,padding.y,color,scale,strokewidth,centering,scale*2+linespacing)
runes.width = width + padding.x*2
runes.height = scale*2*lines + linespacing*(lines-1) + padding.y*2
print(runes:draw())