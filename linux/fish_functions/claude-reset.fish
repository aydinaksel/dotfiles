function claude-reset --description "Clear Claude context: shell snapshots, tasks, projects, todos"
    set --local claude_directory ~/.claude

    for directory in shell-snapshots tasks projects todos
        set --local target $claude_directory/$directory
        if test -d $target
            rm -rf -- $target/
            mkdir $target
        end
    end

    echo "Claude context cleared."
end
