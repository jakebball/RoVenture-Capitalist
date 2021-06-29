local MathUtil = {}

MathUtil.Suffixes = {"k","M","B","T","qd","Qn","sx","Sp","O","N","de","Ud","DD","tdD","qdD","QnD","sxD","SpD","OcD","NvD","Vgn","UVg","DVg","TVg","qtV","QnV","SeV","SPG","OVG","NVG","TGN","UTG","DTG","tsTG","qtTG","QnTG","ssTG","SpTG","OcTG","NoTG","QdDR","uQDR","dQDR","tQDR","qdQDR","QnQDR","sxQDR","SpQDR","OQDDr","NQDDr","qQGNT","uQGNT","dQGNT","tQGNT","qdQGNT","QnQGNT","sxQGNT","SpQGNT", "OQQGNT","NQQGNT","SXGNTL"} 

function MathUtil.Shorten(Input)
    local Negative = Input < 0
	Input = math.abs(Input)

	local Paired = false
	for i,_ in ipairs(MathUtil.Suffixes) do
		if not (Input >= 10^(3*i)) then
			Input = Input / 10^(3*(i-1))
			local isComplex = (string.find(tostring(Input),".") and string.sub(tostring(Input),4,4) ~= ".")
			Input = string.sub(tostring(Input),1,(isComplex and 4) or 3) .. (MathUtil.Suffixes[i-1] or "")
			Paired = true
			break;
		end
	end
	if not Paired then
		local Rounded = math.floor(tonumber(Input))
		Input = tostring(Rounded)
	end

	if Negative then
		return "-"..Input
	end

	return Input
end

function MathUtil.ConvertToHMS(Seconds)
	
	local function Format(Int)
		return string.format("%02i", Int)
	end

	local Minutes = (Seconds - Seconds%60)/60
	Seconds = Seconds - Minutes*60
	local Hours = (Minutes - Minutes%60)/60
	Minutes = Minutes - Hours*60
	return Format(Hours)..":"..Format(Minutes)..":"..Format(Seconds)
end

return MathUtil