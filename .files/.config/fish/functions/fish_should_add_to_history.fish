# fish v4+
# Executed before command is added to history. The first argument to
# `fish_should_add_to_history` is the commandline. History is added *before* a
# command is run, so e.g. :envvar:`status` can't be checked. This is so commands
# that don't finish like `exec` and long-running commands are available in new
# sessions immediately.
# Return 0 to add, or anything else not to.
function fish_should_add_to_history
	# I don't want `git pull`s in my history when I'm in a specific repository
	# if string match -qr '^git pull'
	# 	and string match -qr "^/home/me/my-secret-project/" -- (pwd -P)
	# 	return 1
	# end
	string match -qr "^\s" -- $argv; and return 1
	string match -qr "^clear\$" -- $argv; and return 1
	return 0
end
