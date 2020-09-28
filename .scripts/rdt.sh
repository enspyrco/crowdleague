#!/bin/bash
remotedev --port 8000 &
RD_PID=$!
open http://localhost:8000
firebase emulators:start --import=test/data
# kill the pid for remotedev, which was started in the background 
kill $RD_PID


# windows 
# start http://localhost:8000