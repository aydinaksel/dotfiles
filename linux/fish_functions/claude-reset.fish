function claude-reset --description "Clear Claude context: shell snapshots, tasks, projects, todos"
    set --local claude_directory ~/.claude

    rm -rf $claude_directory/shell-snapshots/*
    rm -rf $claude_directory/tasks/*
    rm -rf $claude_directory/projects/*
    rm -rf $claude_directory/todos/*

    echo "Claude context cleared."
end
