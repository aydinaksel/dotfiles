# Delete per-repo .claude/settings.local.json files under ~/*/.claude/.
# These are prompt-cache files accumulated from "yes forever" approvals.
# Consolidated permissions live in ~/.claude/settings.json instead.
# Skips .claude directories that contain other files (e.g. session locks).
def claude-prune-projects [] {
    let entries = (glob ~/*/.claude/settings.local.json)

    if ($entries | is-empty) {
        print "No per-repo settings.local.json files found."
        return
    }

    for entry in $entries {
        rm $entry
        print $"Removed ($entry)"

        let parent = ($entry | path dirname)
        let remaining = (ls $parent | length)
        if $remaining == 0 {
            rm $parent
            print $"Removed empty ($parent)"
        }
    }
}
