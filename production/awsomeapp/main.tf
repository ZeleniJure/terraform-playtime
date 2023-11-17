module "app_infra" {
  source = "../../module-awsome-app"
  # should really be e.g. source = "git::https://github.com/XY/module-awsome-app?ref=v0.0.1"

  name      = "awsome"
  domains   = ["awsome.app"]
  is_public = true
}
