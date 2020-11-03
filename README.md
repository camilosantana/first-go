# first-go

the first thing i wrote in go

## Summary

here's my first Golang applet i wrote - an end-to-end test that runs terraform that builds a datadog dashboard, modelled straight outta the "terraform up and running" v2 book from gruntworks.

Steps:

- plan and apply terraform config is sibling `datadog` directory.
- capture output from said project
- make simple http get to ensure the dashboard is there

This ensures no one breaks the dashboard lit up on the operations wall.

GithubActions enforces this check via:

```yaml
name: gh-actions/tf-datadog
on:
  pull_request:
    branches:
      - main
    paths:
      - "datadog/**.tf"
      - "datadog/**.auto.tfvars"
```
