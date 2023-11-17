variable "name" {
  description = "Name, such as production or staging"
  type        = string
}

variable "domains" {
  description = "List of domains to expose the application on"
  type        = list(string)
  # Note: we could add some validation here, e.g. each item ends with xy.com
}

variable "is_public" {
  description = "Should we expose this application to the internet"
  type        = bool
  default     = false
}