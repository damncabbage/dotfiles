#!/bin/bash

export PATH="node_modules/.bin:$PATH"
npm run | grep '^  build-ide' >/dev/null && npm run build-ide || pulp build --no-psa --json-errors
