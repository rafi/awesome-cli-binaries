function fish_right_prompt --description 'Write out the right prompt'
	echo -n -s (fish_vcs_prompt) $normal
end
