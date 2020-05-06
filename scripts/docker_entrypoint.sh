#!/bin/bash
/scripts/build.sh -j${NUMBER_OF_DEDICATED_CORES:-1}
/scripts/deploy.sh
