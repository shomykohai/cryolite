function py-venv --wraps='python -m venv .venv && source .venv/bin/activate.fish' --description 'alias py-venv=python -m venv .venv && source .venv/bin/activate.fish'
    python -m venv .venv && source .venv/bin/activate.fish $argv
end
