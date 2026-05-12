function py-venv --wraps='python -m venv .venv && source .venv/bin/activate' --description 'alias py-venv=python -m venv .venv && source .venv/bin/activate'
    python -m venv .venv && source .venv/bin/activate $argv
end
