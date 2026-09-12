#!/usr/bin/env bash
# Link the packages that only make sense on a Mac.
. "$(dirname "${BASH_SOURCE[0]}")/../helper/lib.sh"

step "link linearmouse and opencode"
link linearmouse .config/linearmouse/linearmouse.json
link opencode .config/opencode/opencode.json
