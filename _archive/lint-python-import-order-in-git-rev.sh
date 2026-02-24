#!/usr/bin/env bash

# Import order is a tough one, since there exist some unforseeable exceptions to the general rule.
# I could apply the import order however only to the c1 block. that would be a small gain.



# isort needs real files, doesn't work with here-documents

# always returns 0
# isort --diff --future future --future __future__ --multi-line 3 --project c1 --section-default THIRDPARTY --trailing-comma **.py  # --multi-line: 3-vert-hanging

# may return 1 in case of error
# isort --check-only --future future --future __future__ --multi-line 3 --project c1 --section-default THIRDPARTY --trailing-comma **.py  # --multi-line: 3-vert-hanging



