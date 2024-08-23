-- Yazi config init.

-- State synchronization between multiple Yazi instances
require("session"):setup({
	sync_yanked = true,
})

-- Show symlink in status bar
function Status:name()
	local h = self._tab.current.hovered
	if not h then
		return ui.Line({})
	end

	local linked = ""
	if h.link_to ~= nil then
		linked = " -> " .. tostring(h.link_to)
	end
	return ui.Line(" " .. h.name .. linked)
end

-- Show user/group of files in status bar
function Status:owner()
	local h = self._tab.current.hovered
	if h == nil or ya.target_family() ~= "unix" then
		return ui.Line({})
	end

	return ui.Line({
		ui.Span(ya.user_name(h.cha.uid) or tostring(h.cha.uid)):fg("magenta"),
		ui.Span(":"),
		ui.Span(ya.group_name(h.cha.gid) or tostring(h.cha.gid)):fg("magenta"),
		ui.Span(" "),
	})
end

-- Custom date in status bar
function Status:date()
	local h = self._tab.current.hovered
	if not h then
		return ui.Line({})
	end

	local spans = {}
	local show = {
		modified = { "m", "yellow" },
		created = { "c", "green" },
		accessed = { "a", "blue" },
	}

	for key, display in pairs(show) do
		if h.cha[key] ~= nil and h.cha[key] then
			local time = ya.round(h.cha[key])
			local ok, fmt = pcall(os.date, "%Y-%m-%d %H:%M", time)
			if ok then
				table.insert(spans, ui.Span(display[1] .. " "))
				table.insert(spans, ui.Span(fmt .. " "):fg(display[2]))
			end
		end
	end
	return ui.Line(spans)
end

Status:children_remove(1, Status.LEFT)
Status:children_remove(2, Status.LEFT)
Status:children_remove(3, Status.LEFT)
Status:children_add(Status.name, 3000, Status.LEFT)
Status:children_add(Status.date, 1, Status.RIGHT)
Status:children_add(Status.owner, 2, Status.RIGHT)

function Header:tabs()
	local tabs = #cx.tabs
	local spans = {}
	for i = 1, tabs do
		local text = cx.tabs[i]:name()
		if THEME.manager.tab_width > 2 then
			text = ya.truncate(text .. " " .. cx.tabs[i]:name(), { max = THEME.manager.tab_width })
		end
		if i == cx.tabs.idx then
			spans[#spans + 1] = ui.Span(" " .. text .. " "):style(THEME.manager.tab_active)
		else
			spans[#spans + 1] = ui.Span(" " .. text .. " "):style(THEME.manager.tab_inactive)
		end
	end
	return ui.Line(spans)
end

Header:children_remove(1, Header.LEFT)
Header:children_remove(2, Header.RIGHT)
Header:children_add(Header.tabs, Header.LEFT)

function Linemode:size_and_mtime()
	local year = os.date("%Y")
	local time = (self._file.cha.modified or 0) // 1

	if time > 0 and os.date("%Y", time) == year then
		time = os.date("%b %d %H:%M", time)
	else
		time = time and os.date("%b %d  %Y", time) or ""
	end

	local size = self._file:size()
	return ui.Line(string.format(" %s %s ", size and ya.readable_size(size) or "-", time))
end
