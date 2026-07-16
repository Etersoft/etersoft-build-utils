# fish completion for gita (gitask)
# https://etersoft.ru

# Disable file completions by default
complete -c gita -f
complete -c gitask -f

# Subcommands
set -l subcommands new run commit test add deps copy find log show ls quota cancel approve acl wait share delsub rebuild get task

# First argument: subcommands
complete -c gita -n __fish_use_subcommand -a "$subcommands"
complete -c gitask -n __fish_use_subcommand -a "$subcommands"

# --- ls ---
complete -c gita -n '__fish_seen_subcommand_from ls' -s a -l all -d 'List all users, all states'
complete -c gita -n '__fish_seen_subcommand_from ls' -s u -l user -d 'List tasks for USER' -r
complete -c gita -n '__fish_seen_subcommand_from ls' -s s -l state -d 'Filter by state' -xa 'NEW AWAITING PENDING BUILDING COMMITTING TESTED FAILED DONE EPERM POSTPONED ALL'
complete -c gita -n '__fish_seen_subcommand_from ls' -s r -l repo -d 'Filter by repo' -xa 'sisyphus p10 p11 c10f2'
complete -c gita -n '__fish_seen_subcommand_from ls' -s w -d 'Watch mode, refresh every N seconds'

# --- run ---
complete -c gita -n '__fish_seen_subcommand_from run' -l test-only -d 'Test only'
complete -c gita -n '__fish_seen_subcommand_from run' -l commit -d 'Commit'
complete -c gita -n '__fish_seen_subcommand_from run' -s m -d 'Message' -r

# --- commit ---
complete -c gita -n '__fish_seen_subcommand_from commit' -s m -d 'Message' -r

# --- test ---
complete -c gita -n '__fish_seen_subcommand_from test' -s m -d 'Message' -r

# --- add / Add ---
complete -c gita -n '__fish_seen_subcommand_from add Add' -s h -l help -d 'Show help'
complete -c gita -n '__fish_seen_subcommand_from add Add' -a 'del copy repo build rebuild' -d 'Add subcommand'

# --- copy ---
complete -c gita -n '__fish_seen_subcommand_from copy' -a 'to' -d 'Target branch follows'
complete -c gita -n '__fish_seen_subcommand_from copy' -n '__fish_seen_subcommand_from to' -a 'p10 p11 sisyphus from'

# --- acl ---
complete -c gita -n '__fish_seen_subcommand_from acl' -a 'Sisyphus p10 p11 c10f2' -d 'Branch'
complete -c gita -n '__fish_seen_subcommand_from acl' -a 'show add del leader' -d 'ACL command'

# --- approve ---
complete -c gita -n '__fish_seen_subcommand_from approve' -s m -d 'Message' -r

# --- wait ---
complete -c gita -n '__fish_seen_subcommand_from wait' -s q -l quiet -d 'Quiet mode, no spinner'

# --- get ---
complete -c gita -n '__fish_seen_subcommand_from get' -a 'subtask last' -d 'Get subcommand'

# Also handle gitask
complete -c gitask -n '__fish_seen_subcommand_from ls' -s a -l all -d 'List all users, all states'
complete -c gitask -n '__fish_seen_subcommand_from ls' -s u -l user -d 'List tasks for USER' -r
complete -c gitask -n '__fish_seen_subcommand_from ls' -s s -l state -d 'Filter by state' -xa 'NEW AWAITING PENDING BUILDING COMMITTING TESTED FAILED DONE EPERM POSTPONED ALL'
complete -c gitask -n '__fish_seen_subcommand_from ls' -s r -l repo -d 'Filter by repo' -xa 'sisyphus p10 p11 c10f2'
complete -c gitask -n '__fish_seen_subcommand_from ls' -s w -d 'Watch mode, refresh every N seconds'
complete -c gitask -n '__fish_seen_subcommand_from run' -l test-only -d 'Test only'
complete -c gitask -n '__fish_seen_subcommand_from run' -l commit -d 'Commit'
complete -c gitask -n '__fish_seen_subcommand_from run' -s m -d 'Message' -r
complete -c gitask -n '__fish_seen_subcommand_from commit' -s m -d 'Message' -r
complete -c gitask -n '__fish_seen_subcommand_from test' -s m -d 'Message' -r
complete -c gitask -n '__fish_seen_subcommand_from add Add' -s h -l help -d 'Show help'
complete -c gitask -n '__fish_seen_subcommand_from add Add' -a 'del copy repo build rebuild' -d 'Add subcommand'
complete -c gitask -n '__fish_seen_subcommand_from acl' -a 'Sisyphus p10 p11 c10f2' -d 'Branch'
complete -c gitask -n '__fish_seen_subcommand_from acl' -a 'show add del leader' -d 'ACL command'
complete -c gitask -n '__fish_seen_subcommand_from approve' -s m -d 'Message' -r
complete -c gitask -n '__fish_seen_subcommand_from wait' -s q -l quiet -d 'Quiet mode, no spinner'
complete -c gitask -n '__fish_seen_subcommand_from get' -a 'subtask last' -d 'Get subcommand'
