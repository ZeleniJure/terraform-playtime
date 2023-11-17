data "google_project" "project" {}

module "lb-http" {
  source  = "GoogleCloudPlatform/lb-http/google//modules/serverless_negs"
  version = "~> 9.0"

  project = data.google_project.project.number
  name    = "${var.name}-cnd"

  managed_ssl_certificate_domains = var.domains
  ssl                             = true
  https_redirect                  = true
  load_balancing_scheme           = var.is_public ? "EXTERNAL" : "INTERNAL_SELF_MANAGED"

  backends = {
    default = {
      groups = [
        for neg in google_compute_region_network_endpoint_group.default :
        {
          group = neg.id
        }
      ]

      enable_cdn = true

      log_config = {
        enable      = true
        sample_rate = 1.0
      }

      iap_config = {
        enable               = false
        oauth2_client_id     = null
        oauth2_client_secret = null
      }

      description             = null
      custom_request_headers  = ["X-Client-Geo-Location: {client_region_subdivision}, {client_city}"]
      custom_response_headers = ["X-Cache-Hit: {cdn_cache_status}"]
      security_policy         = null
    }
  }
}
