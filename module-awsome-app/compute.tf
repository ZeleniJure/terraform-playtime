resource "google_project_service" "cloudrun_api" {
  service            = "run.googleapis.com"
  disable_on_destroy = false
}

data "google_cloud_run_locations" "default" { }

resource "google_cloud_run_v2_service" "default" {
  for_each = toset(data.google_cloud_run_locations.default.locations)

  name     = "${var.name}-service-${each.value}"
  location = each.value

  template {
    # NOTE: Not doing this, since terraform most likely shouldn't be a deploy tool.
    #       Delivery system should deploy correct image and set env vars.
    #       Potentially we could set initial values here (on creation only, and
    #       set the lifecycle policy to ignore these afterwards)
    # containers {
    #   image = "us-docker.pkg.dev/cloudrun/container/hello:latest"
    #   env {
    #     name  = "INSTANCE_CONNECTION_NAME"
    #     value = google_sql_database_instance.default.connection_name
    #   }
    #   env {
    #     name = "DB_USER"
    #     value_source {
    #       secret_key_ref {
    #         secret  = google_secret_manager_secret.dbuser.secret_id
    #         version = "latest"
    #       }
    #     }
    #   }
    #   volume_mounts {
    #     name       = "cloudsql"
    #     mount_path = "/cloudsql"
    #   }
    # }
    volumes {
      name = "cloudsql"
      cloud_sql_instance {
        instances = [google_sql_database_instance.default.connection_name]
      }
    }
  }
  client     = "terraform"
  depends_on = [google_project_service.cloudrun_api, google_project_service.sqladmin_api]
}

resource "google_cloud_run_service_iam_member" "default" {
  for_each = toset(data.google_cloud_run_locations.default.locations)

  location = google_cloud_run_v2_service.default[each.key].location
  project  = google_cloud_run_v2_service.default[each.key].project
  service  = google_cloud_run_v2_service.default[each.key].name
  role     = "roles/run.invoker"
  member   = "allUsers"
}

resource "google_compute_region_network_endpoint_group" "default" {
  for_each = toset(data.google_cloud_run_locations.default.locations)

  name                  = "${var.name}--neg--${each.key}"
  network_endpoint_type = "SERVERLESS"
  region                = google_cloud_run_v2_service.default[each.key].location
  cloud_run {
    service = google_cloud_run_v2_service.default[each.key].name
  }
}
