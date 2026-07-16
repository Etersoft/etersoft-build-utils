# bash completion for gita (gitask)
# https://etersoft.ru

_gita()
{
	local cur prev words cword
	_init_completion || return

	local subcommands="new run commit test add Add deps copy find log show ls quota cancel approve acl wait share delsub rebuild get task"

	case $cword in
		1)
			COMPREPLY=($(compgen -W "$subcommands" -- "$cur"))
			return
			;;
	esac

	local cmd=${words[1]}
	case $cmd in
		ls)
			case $prev in
				--user|-u)
					return
					;;
				--state|-s)
					COMPREPLY=($(compgen -W "NEW AWAITING PENDING BUILDING COMMITTING TESTED FAILED DONE EPERM POSTPONED ALL" -- "$cur"))
					return
					;;
				--repo|-r)
					COMPREPLY=($(compgen -W "sisyphus p10 p11 c10f2" -- "$cur"))
					return
					;;
			esac
			COMPREPLY=($(compgen -W "--all -a --user -u --state -s --repo -r -w" -- "$cur"))
			return
			;;
		run|commit|test)
			case $prev in
				-m)
					return
					;;
			esac
			local opts="-m"
			[[ $cmd == run ]] && opts="$opts --test-only --commit"
			COMPREPLY=($(compgen -W "$opts" -- "$cur"))
			return
			;;
		add|Add)
			case $prev in
				del|copy|repo|build|rebuild)
					return
					;;
			esac
			case $cur in
				-*)
					COMPREPLY=($(compgen -W "--help" -- "$cur"))
					return
					;;
			esac
			# after task number, suggest add subcommands
			if [[ ${words[2]} =~ ^#?[0-9]+$ ]] || [[ $cword -eq 2 ]] ; then
				COMPREPLY=($(compgen -W "del copy repo build rebuild" -- "$cur"))
				return
			fi
			;;
		acl)
			case $prev in
				acl)
					COMPREPLY=($(compgen -W "Sisyphus p10 p11 c10f2" -- "$cur"))
					return
					;;
			esac
			# second/third arg: package or branch, then commands
			case $cur in
				show|add|del|leader)
					return
					;;
			esac
			;;
		approve)
			case $prev in
				-m)
					return
					;;
			esac
			COMPREPLY=($(compgen -W "-m" -- "$cur"))
			return
			;;
		wait)
			COMPREPLY=($(compgen -W "-q --quiet" -- "$cur"))
			return
			;;
		copy)
			# after "to", suggest branches
			local i has_to=0
			for ((i=2; i<cword; i++)) ; do
				if [[ ${words[i]} == to ]] ; then
					has_to=1
					break
				fi
			done
			if [[ $has_to -eq 1 ]] ; then
				COMPREPLY=($(compgen -W "p10 p11 sisyphus from" -- "$cur"))
			else
				COMPREPLY=($(compgen -W "to" -- "$cur"))
			fi
			return
			;;
		get)
			case ${words[2]:-} in
				"")
					COMPREPLY=($(compgen -W "subtask last" -- "$cur"))
					return
					;;
			esac
			;;
		cancel|delsub|log|show|share)
			# these take task numbers, no special completions
			;;
	esac
} &&
complete -F _gita gita gitask
