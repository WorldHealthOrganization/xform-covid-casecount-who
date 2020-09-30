#!/bin/bash
source "${GITHUB_WORKSPACE}/.github/scripts/shutils.sh"
###############################################################################
# Install xform specific dependencies.
###############################################################################

R -e "remotes::install_github('WorldHealthOrganization/geoutils', upgrade = FALSE)"

# TODO: Uncomment and ddd additional packages needed for your transformer.
#installAptPackages pkg1 pkg2 pkg3
exit 0
