# Can be provided with TF_VAR_GITHUB_TOKEN environment variable
variable "GITHUB_TOKEN" {}

# Can be provided with TF_VAR_GITHUB_API_URL environment variable
variable "GITHUB_API_URL" {
  default = "https://api.github.com/"
}
