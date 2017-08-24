#!/usr/bin/env bats

# =======================================================================
#
# Testing the project
#
# @see https://github.com/sstephenson/bats
# @see https://blog.engineyard.com/2014/bats-test-command-line-tools
#
# =======================================================================

# Test if node is available
@test "Node is available" {
	result="$(docker run --entrypoint=/bin/bash ${DOCKER_APP_IMAGE_NAME} -c 'node -v')"
	[[ "$result" =~ ^v[0-9]+[.][0-9]+[.][0-9]+$ ]]
}

# Test app version available
@test "App version is available" {
	result="$(docker run --entrypoint=/bin/bash ${DOCKER_APP_IMAGE_NAME} -c 'node -e "console.log(require(\"./package.json\").version);"')"
	[[ "$result" =~ ^[0-9]+[.][0-9]+[.][0-9]+$ ]]
}
