#!/bin/bash
if [ -n "$-j$NUMBER_OF_DEDICATED_CORES" ]; then
  /scripts/build.sh -j$NUMBER_OF_DEDICATED_CORES
else
  /scripts/build.sh
fi
/scripts/deploy.sh
