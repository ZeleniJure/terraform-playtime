module "app_infra" {
  source = "../../module-awsome-app"

  name      = "test-awsome"
  domains   = ["test-awsome.app"]
  is_public = false
}
