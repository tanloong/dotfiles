set -o vi
alias c=clear
alias q=exit
sshd
printf "SSH Server is running at %s@%s -p 8022\n" \
	$(whoami) \
	$(ifconfig | grep -E 'inet 192[.0-9]+' -o | sed -E 's/^\s*inet //')
