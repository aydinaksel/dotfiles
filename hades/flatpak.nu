#!/usr/bin/env nu

let desired = [
    # GNOME CORE
    "org.gnome.Boxes"
    "org.gnome.Calculator"
    "org.gnome.Calendar"
    "org.gnome.Characters"
    "org.gnome.Contacts"
    "org.gnome.Connections"
    "org.gnome.Papers"
    "org.gnome.TextEditor"
    "org.gnome.Snapshot"

    # GNOME CIRCLE
    "io.bassi.Amberol"
    "com.rafaelmardojai.Blanket"
    "app.drey.EarTag"
    "com.github.finefindus.eyedropper"
    "be.alexandervanhee.gradia"
    "dev.bragefuglseth.Keypunch"
    "io.gitlab.news_flash.NewsFlash"
    "io.gitlab.liferooter.TextPieces"
    "io.github.idevecore.Valuta"
    "com.github.hugolabe.Wike"

    # OTHER
    "it.mijorus.whisper"
    "com.bitwarden.desktop"
    "com.fastmail.Fastmail"
    "md.obsidian.Obsidian"
    "org.libreoffice.LibreOffice"
    "org.inkscape.Inkscape"
    "io.missioncenter.MissionCenter"
    "com.stremio.Stremio"
    "com.rustdesk.RustDesk"
    "org.gramps_project.Gramps"
]

let installed = (flatpak list --app --columns=application | lines)

let to_install = ($desired | where {|app| $app not-in $installed})
let to_remove = ($installed | where {|app| $app not-in $desired})

if ($to_install | is-not-empty) {
    print $"Installing: ($to_install | str join ', ')"
    flatpak install --noninteractive flathub ...$to_install
}

if ($to_remove | is-not-empty) {
    print $"Not in list: ($to_remove | str join ', ')"
    flatpak uninstall --noninteractive ...$to_remove
}

if ($to_install | is-empty) and ($to_remove | is-empty) {
    print "Flatpaks are in sync."
}
