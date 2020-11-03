# first-go

the first thing i wrote in go

## Summary

here's my first Golang applet i wrote - an end-to-end test that runs terraform that builds a datadog dashboard, gets output from terraform then turns around and makes calls to datadog to make sure the dashboard is there (the idea is the procore SREs are idiots and they will break shit. so i add a github action that kicks off and runs my end-to-end to make sure they don't break my dashboard. then i turn on strict checking on the repo to prevent them from merging their garbage to master)
