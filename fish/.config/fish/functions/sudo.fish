# Work around from: https://github.com/fish-shell/fish-shell/issues/288
# to make history expansion work for sudo
function sudo
    if test "$argv" = !!
        eval command sudo $history[1]
    else
        command sudo $argv
    end
end