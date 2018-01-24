resource "github_team" "community" {
  name        = "community"
  description = "the community contributors"
  privacy     = "closed" #more open than secret *shrug*
}

resource "github_team_membership" "rackergs" {
  team_id  = "${github_team.community.id}"
  username = "rackergs"
  role     = "member"
}

