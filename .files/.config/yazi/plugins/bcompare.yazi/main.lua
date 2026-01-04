local function info(content)
	return ya.notify {
		title = "Beyond Compare",
		content = content,
		timeout = 5,
	}
end

local selected_url = ya.sync(function()
	for _, u in pairs(cx.active.selected) do
		return u.cache or u
	end
end)

local hovered_url = ya.sync(function()
	local h = cx.active.current.hovered
	return h and (h.path or h.url) -- TODO: remove "or h.url"
end)

return {
	entry = function()
		local a, b = selected_url(), hovered_url()
		if not a then
			return info("No file selected")
		elseif not b then
			return info("No file hovered")
		end

		local _, err = Command("bcompare"):arg(tostring(a)):arg(tostring(b))
			:stderr(Command.PIPED)
			:output()

		if err ~= nil then
			ya.notify({
				title = "Failed to run bcompare command",
				content = "Status: " .. err,
				timeout = 5.0,
				level = "error",
			})
		end
	end,
}
