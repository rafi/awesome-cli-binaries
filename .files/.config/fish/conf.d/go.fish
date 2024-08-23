function gg
	if not set -q argv[1]
		go mod tidy
	else
		go get -u $argv
	end
end
