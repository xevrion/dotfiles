if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Added by jcode installer
if not contains "/home/xevrion/.local/bin" $PATH
    set -gx PATH "/home/xevrion/.local/bin" $PATH
end
