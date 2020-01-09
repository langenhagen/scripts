#!/bin/bash
# Identify possible issues in a given ini file.

ini_file="$1"

grep -EHn "[^ ]=" "$ini_file"
grep -EHn "=[^ ]" "$ini_file"
grep -EHn ",[[:space:]]" "$ini_file"
