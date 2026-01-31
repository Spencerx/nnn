#!/bin/sh
# Verify disk usage: run du from a path and print in GB for comparison with nnn.
# Usage: ./verify-du.sh [path]
# Default path: current directory (.)
# Compare the output with nnn's du display when run from the same path.

path="${1:-.}"
echo "Path: $path"
echo ""

# GNU du: -s = summary, default block size 1024 bytes
# So "du -s" output * 1024 = bytes
if command -v du >/dev/null 2>&1; then
	echo "du -s (1024-byte blocks, same as 'du -sh'):"
	blocks=$(du -s "$path" 2>/dev/null | cut -f1)
	if [ -n "$blocks" ]; then
		# bytes = blocks * 1024; GB = bytes / 1024^3
		bytes=$((blocks * 1024))
		gb=$(echo "scale=3; $bytes / 1073741824" | bc 2>/dev/null)
		echo "  $blocks 1K-blocks"
		echo "  ${gb} GB (bytes: $bytes)"
	else
		echo "  (failed or permission denied)"
	fi
	echo ""

	# Also show in 512-byte blocks (st_blocks units, what nnn uses for disk usage)
	echo "Equivalent in 512-byte blocks (nnn st_blocks units):"
	if [ -n "$blocks" ]; then
		blocks512=$((blocks * 2))
		echo "  $blocks512 512-byte blocks"
	fi
fi
