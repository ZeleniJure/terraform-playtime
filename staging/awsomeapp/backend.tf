terraform {
  backend "gcs" {
    # NOTE: all of this should go to the CI / passed locally when running terraform
    #       Authentication: done outside, terraform doesn't care!
    #       bucket names: each environment needs a separate one. Naming should be consistent (e.g. team + project name + environment)
    #       Prefix: used to separate various apps (e.g. awsomeapp/state, mongodb/state, pagerduty/state)

    # bucket  = "BUCKET_NAME"
    # prefix  = "app/state"
  }
}
