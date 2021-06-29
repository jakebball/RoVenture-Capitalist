local SchedulerUtils = {}

local RunService = game:GetService("RunService")
local threads = {}

RunService.Stepped:Connect(function ()
	local now = tick()
	local resumePool
	
	for thread, resumeTime in pairs(threads) do
		-- Resume if we're reasonably close enough.
		local diff = (resumeTime - now)
		
		if diff < 0.005 then
			if not resumePool then
				resumePool = {}
			end
			
			table.insert(resumePool, thread)
		end
	end
	
	if resumePool then
		for _,thread in pairs(resumePool) do
			threads[thread] = nil
			coroutine.resume(thread, now)
		end
	end
end)

function SchedulerUtils.Wait(t)
	local t = tonumber(t) or 1 / 30
	local start = tick()
	
	local thread = coroutine.running()
	threads[thread] = start + t
	
	-- Wait for the thread to resume.
	local now = coroutine.yield()
	return now - start, elapsedTime()
end


return SchedulerUtils