#!/bin/bash
# Force colorscheme because zenburn is terrible for diffs.
vimdiff "+colorscheme elflord" "$2" "$5"
