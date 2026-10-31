package main

import (
	"context"
	"testing"

	"github.com/pando85/containers/testhelpers"
)

func Test(t *testing.T) {
	ctx := context.Background()
	image := testhelpers.GetTestImage("ghcr.io/pando85/forgejo-runner-gc:rolling")

	testhelpers.TestCommandSucceeds(t, ctx, image, nil, "/bin/forgejo-runner", "--version")
	testhelpers.TestCommandSucceeds(t, ctx, image, nil, "sh", "-c",
		"forgejo-runner generate-config | grep -q 'workdir_cleanup_age: 24h' && forgejo-runner generate-config | grep -q 'idle_cleanup_interval: 10m'")
	testhelpers.TestCommandSucceeds(t, ctx, image, nil, "sh", "-c", "test \"$(id -u)\" = 1001")
	testhelpers.TestFileExists(t, ctx, image, "/usr/local/bin/yq", nil)
	testhelpers.TestCommandSucceeds(t, ctx, image, nil, "docker", "--version")
}
