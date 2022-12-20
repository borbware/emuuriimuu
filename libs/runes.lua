
require "ext.utf8"
require "libs.utils"
local savedrunes={}

local function splitToSyllables(text)
	local VOWELS="aeiouyäö"--local CONSONANTS="hjklmnprstvŋ"
	local tavut=text:split("-")--CVVVCCC
	local word={}
	local wordlen=0
	for i,tavu in ipairs(tavut)do
		local chars={const1="",vowel="",const2="",}
		local j=1
		for tavu_index=1,7 do
			local c=utf8sub(tavu,j,j)
			if c==""then break end
			if tavu_index==1 then
				if not VOWELS:find(c)then
					chars.const1=c
					j=j+1
				end
			elseif tavu_index>=2 and tavu_index<=4 then
				if VOWELS:find(c)then
					chars.vowel=chars.vowel..c
					j=j+1
				end
			elseif tavu_index>=5 then
				if not VOWELS:find(c)then
					chars.const2=chars.const2..c
					j=j+1
				end
			end
		end
		chars.c1=utf8sub(chars.const1,1,1)
		chars.v1=utf8sub(chars.vowel,1,1)
		chars.v2=utf8sub(chars.vowel,2,3)
		if chars.v1..chars.v2=="uae"then
			chars.v1,chars.v2="uae","uae"
		elseif chars.v2==""then--wide
			chars.v1,chars.v2=chars.v1.."1",chars.v1.."2"
		end
		chars.c2=utf8sub(chars.const2,1,1)
		chars.c3=utf8sub(chars.const2,2,2)
		chars.c4=utf8sub(chars.const2,3,3)
		to(word,chars)
	end
	return word
end

local function printruneline(svg,lin,x,y,color,scale,strokeWidth,i,y_linebreak,viivs_drawn)
	local len=0
	local wordobj=savedrunes[lin]--words,syllables
	wordobj.words=wordobj.words or lin:split(" ")
	for j,text in ipairs(wordobj.words)do
		local word=wordobj.syllables[text] or splitToSyllables(text)
		wordobj.syllables[text]=word
		word.len,viivs_drawn=printruneword(svg,word,x+len,y+(i-1)*y_linebreak,color,scale,strokeWidth,viivs_drawn)
		len=len+word.len
		if j<#wordobj.words then len=len+scale*3 end
	end
	wordobj.len=len
	return len,viivs_drawn
end

function printrunes(svg,textline,x,y,color,scale,strokeWidth,centered,y_linebreak)
	y_linebreak=y_linebreak or 0
	local lines=tolines(textline)
	local viivs_drawn=0
	local fulllen=0
	for i,lin in ipairs(lines)do
		local len_ref,line_len=0,0
		if not savedrunes[lin]then
			savedrunes[lin]={syllables={}}
		end
		if centered then
			len_ref=savedrunes[lin].len or printruneline(svg,lin,x,136,color,scale,strokeWidth,i,0,0)
		end
		line_len,viivs_drawn=printruneline(svg,lin,x-len_ref/2,y,color,scale,strokeWidth,i,y_linebreak,viivs_drawn)
		fulllen=max(fulllen,line_len)
	end
	return fulllen,#lines,viivs_drawn
end

local wordlines={
	a1={2,4},a2={2,4,5},
	e1={2,4,5},e2={2,4},
	i1={2},i2={2,5},
	o1={2,5},o2={2,5},
	u1={5},u2={5},
	y1={5,7},y2={5},
	["ä1"]={1,2,4},["ä2"]={1,2,4,5},
	["ö1"]={1,2,5},["ö2"]={1,2,5},
	a={2,3,4,6},
	e={2,3,4,5},
	i={2,3,6},
	o={2,3,5,6},
	u={5,6},
	y={5,6,7},
	uae={2,3,4,5,6},
	["ä"]={1,2,3,4,6},
	["ö"]={1,2,3,5,6},
	h={3,4,5},
	j={2,5},
	k={5,7},--{2,5,7},--{3,4,5,6},
	l={3,5,6},
	m={2,4,5},
	n={2,3,6},
	["ŋ"]={2,3,5},
	p={2,4,6},--{2,3,4,6},
	r={4,6,7},
	s={1,3,4},--{1,3,4,5},
	t={1,2,3},--{1,3,5,6},
	v={5,6},
	all={1,2,3,4,5,6,7},
}
local linecoords={
	{{0,0},{1,0}},
	{{1,0},{0,1}},
	{{1,0},{1,1}},
	{{0,1},{1,1}},
	{{0,1},{1,2}},
	{{1,1},{1,2}},
	{{1,2},{0,2}},
}
function printruneword(svg,word,x,y,color,scale,strokeWidth,viivs_drawn)
	local function drawChar(lines,x,y,color,flip)
		if not lines then return 0 end
		if flip then x=x+scale end
		local k=flip and -1 or 1
		local len=0
		for i,lin in ipairs(lines)do
            local coord=linecoords[lin]
            svg:addLine(
                x+k*coord[1][1]*scale,y+coord[1][2]*scale,
                x+k*coord[2][1]*scale,y+coord[2][2]*scale,
                color,strokeWidth)
            viivs_drawn=viivs_drawn+1
            len=scale
		end
		return len
	end
	local len=0
	for i,chars in ipairs(word)do
		len=len+drawChar(wordlines[chars.c1],x+len,y,color,true)-->

		len=len+drawChar(wordlines[chars.v1],x+len,y,color)		--<
		len=len+drawChar(wordlines[chars.v2],x+len,y,color,true)-->
		local len1=len
		len=len+drawChar(wordlines[chars.c2],x+len,y,color)		--<
		drawChar(wordlines[chars.c3],x+len1,y,color)			--<
		drawChar(wordlines[chars.c4],x+len1,y,color)			--<
		if i<#word then len=len+scale end
	end
	return len,viivs_drawn
end