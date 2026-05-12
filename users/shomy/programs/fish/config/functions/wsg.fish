function wsg
    if test (count $argv) -eq 0
        cd /mnt/workspace/GitHub
    else
        cd /mnt/workspace/GitHub/$argv
    end
end
