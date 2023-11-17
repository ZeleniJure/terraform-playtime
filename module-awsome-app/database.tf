locals {
  deletion_protection = true
}

resource "google_project_service" "sqladmin_api" {
  service            = "sqladmin.googleapis.com"
  disable_on_destroy = false
}

resource "google_sql_database_instance" "default" {
  # NOTE: not configuring read replicas
  name             = "${var.name}-pgsql15"
  database_version = "POSTGRES_15"

  settings {
    tier = "db-f1-micro"
    password_validation_policy {
      min_length                  = 6
      complexity                  = "COMPLEXITY_DEFAULT"
      reuse_interval              = 2
      disallow_username_substring = true
      enable_password_policy      = true
    }

    availability_type = "REGIONAL"
    backup_configuration {
      enabled                        = true
      binary_log_enabled             = true
      point_in_time_recovery_enabled = true
    }

    deletion_protection_enabled = local.deletion_protection

    database_flags {
      name  = "cloudsql.iam_authentication"
      value = "on"
    }
  }
  deletion_protection = local.deletion_protection
  depends_on          = [google_project_service.sqladmin_api]
}

resource "google_sql_user" "iam_service_account_user" {
  # For Postgres only, GCP requires omitting the ".gserviceaccount.com" suffix
  # from the service account email.
  name     = "serviceAccount:${data.google_project.project.number}-compute@developer"
  instance = google_sql_database_instance.default.name
  type     = "CLOUD_IAM_SERVICE_ACCOUNT"
}

