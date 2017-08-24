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
@test "Node  is available" {
	result="$(docker run ${DOCKER_APP_IMAGE_NAME} node --version)"
	[[ "$result" == *"v"* ]]
}
