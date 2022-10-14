#!/bin/bash

# Copyright The Shipwright Contributors
#
# SPDX-License-Identifier: Apache-2.0

# Check the latest image and replace

# Usage
# ./check-latest-image.sh <FILE> <IMAGE> <IMAGE_URL>

set -euo pipefail

# Check the number of arguments passed and exit if less than three
if [ $# -lt 3 ]; then
	echo "USAGE: $0 <FILE> <IMAGE> <IMAGE_URL>"
	exit 1
fi

# Set environment variables
IMAGE=$(printf '%s\n' "$(echo ${1})" | sed -e 's/[]\/$*.^[]/\\&/g')
CURRENT_TAG=$(printf '%s\n' "$(grep -r -h -m 1 -o ${1}'[^ ]*' ${3} | head -n 1 | cut -d':' -f2)" | sed -e 's/[]\/$*.^[]/\\&/g')
LATEST_TAG=$(printf '%s\n' "$(curl -s ${2} | jq -r '.name')" | sed -e 's/[]\/$*.^[]/\\&/g')
if echo ${IMAGE} | grep trivy 2>&1>/dev/null; then
	LATEST_TAG=$(printf '%s\n' "$(curl -s ${2} | jq -r '.name')" | sed -e 's/[]\/$*.^[]/\\&/g')
	LATEST_TAG="${LATEST_TAG:1}"
fi
DIRECTORY=${3}

# Search and replace the images with the latest
find ${DIRECTORY} -type f -exec sed -i "s/$IMAGE\:$CURRENT_TAG/$IMAGE\:$LATEST_TAG/g" {} \;
