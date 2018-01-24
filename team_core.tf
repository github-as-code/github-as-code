resource "github_team" "core" {
  name        = "core"
  description = "the core contributors"
  privacy     = "closed" #more open than secret *shrug*
}

resource "github_team_membership" "gregswift" {
  team_id  = "${github_team.core.id}"
  username = "gregswift"
  role     = "maintainer"
}
