package.path = package.path .. ";" .. "..\\?.lua"
require "ext.svg-lua.svg"
require "libs.runes"

---------------------- 
-- EDIT THESE LINES:
---------------------- 

local runetext="e-muu-rom"
runetext=[[e-rit-täem mui-nae-se' u-to-pia'
us-seem-mi-ter raa-ha'-o-ma-siks
o-sot-taa-tun-neet me-täh-heŋ-ŋet
]]
--runetext="mui-nae-se'\nu-to-piam\nme-täh-heŋ-ŋet"
runetext="mui-nae-se' u-to-piam me-täh-heŋ-ŋet"
runetext="skan-ne-roe-ja"

local padding={
    x=50,
    y=50,
}
local scale=50
local linespacing=scale
local centering=true
local centeredgrid=true
local strokewidth=7
local strokelinecap="round"
local color="#30346d"
--140c1c black
--30346d dark blue
--deeed6 white

---------------------- 
-- DON'T EDIT:
---------------------- 

local xoffset=0
if centering then--calculate offset
    local temprunes = svg:create()
    local width = printrunes(temprunes,runetext,padding.x,padding.y,color,scale,strokewidth,strokelinecap,centering,scale*2+linespacing,centeredgrid)
    xoffset=width/2
end

local runes = svg:create()
local width,lines = printrunes(runes,runetext,padding.x+xoffset,padding.y,color,scale,strokewidth,strokelinecap,centering,scale*2+linespacing,centeredgrid)
runes.width = width + padding.x*2
runes.height = scale*2*lines + linespacing*(lines-1) + padding.y*2
print(runes:draw())