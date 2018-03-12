REM start counter collection
logman start "Memory Counters"
timeout /t 5
REM add a timeout for some short period
REM to allow the collection to start
REM do something interesting here
REM stop the counter collection
logman stop "Memory Counters"
timeout /t 5
REM make sure to wait 5 to ensure its stopped
