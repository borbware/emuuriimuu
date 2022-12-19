to=table.insert
max=math.max

function tolines(str)
	local l={}
	for s in str:gmatch("[^\r\n]+")do to(l,s)end
	return l
end

function string:split(delimiter)--jared allard --https://gist.github.com/jaredallard/ddb152179831dd23b230
	local result={}
	local from=1
	local delim_from,delim_to=string.find(self,delimiter,from)
	while delim_from do
		to(result,string.sub(self,from,delim_from-1))
		from=delim_to+1
		delim_from,delim_to=string.find(self,delimiter,from)
	end
	to(result,string.sub(self,from))
	return result
end