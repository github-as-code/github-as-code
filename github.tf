provider "github" {
  version      = "v0.1.1"
  token        = "${var.GITHUB_TOKEN}"
  organization = "github-as-code"
  base_url     = "${var.GITHUB_API_URL}"
}