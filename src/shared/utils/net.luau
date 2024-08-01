local ecr = require("@ecr")

local function event_queue(event)
	local packet_queue = ecr.queue()

	if event.on then
		event.on(function(packet)
			packet_queue:add(packet)
		end)
	elseif event.set_callback then
		event.set_callback(function(packet)
			packet_queue:add(packet)
		end)
	else
		error("event must have an 'on' or 'set_callback' method")
	end

	return packet_queue
end

return {
	event_queue = event_queue,
}
