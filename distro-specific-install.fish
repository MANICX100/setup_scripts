function inst
	switch $osinfo
	    case fedora
	    		sudo dnf install $argv
	    case arch
			paru -S $argv
	    case debian
			sudo nala install $argv
	    case '*'
			brew install $argv
	end
end


function remove
	switch $osinfo
	    case fedora
			sudo dnf remove $argv
	    case arch
			paru -Rns $argv
	    case debian
			sudo nala autoremove $argv
	    case '*'
			brew uninstall $argv
	end
end
