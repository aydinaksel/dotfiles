# Clear Claude context: shell snapshots, tasks, projects, todos
def claude-reset [] {
    let claude_directory = ($nu.home-dir | path join ".claude")

    for directory in [shell-snapshots tasks projects todos] {
        let target = ($claude_directory | path join $directory)
        if ($target | path exists) {
            rm -rf $target
            mkdir $target
        }
    }

    print "Claude context cleared."
}
