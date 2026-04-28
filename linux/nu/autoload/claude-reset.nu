# Clear Claude context: session, conversation, and ephemeral state
def claude-reset [] {
    let claude_directory = ($nu.home-dir | path join ".claude")

    let directories = [
        shell-snapshots
        tasks
        projects
        todos
        sessions
        session-env
        file-history
        plans
        paste-cache
    ]

    for directory in $directories {
        let target = ($claude_directory | path join $directory)
        if ($target | path exists) {
            rm -rf $target
            mkdir $target
        }
    }

    let history_file = ($claude_directory | path join "history.jsonl")
    if ($history_file | path exists) {
        rm $history_file
    }

    print "Claude context cleared."
}
