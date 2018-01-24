resource "github_repository" "terraform-github" {
  name = "terraform-github"

  # Make the repo public.. typical on free GitHub accounts
  private = false

  # We auto init so that github_branch_protection works
  auto_init = true
}

resource "github_branch_protection" "terraform-github-master" {
  # As part of our SDLC we require that master branch can not be merged to unless criteria is met

  repository = "${github_repository.terraform-github.name}"
  branch     = "master"

  # enforce protection on admins
  enforce_admins = true

  # all status checks pass
  required_status_checks {
    strict         = true
    contexts       = []
  }

  # Tune review requirements
  required_pull_request_reviews {
    # New commits should invalidate reviews
    dismiss_stale_reviews = true
  }

  depends_on = ["github_repository.terraform-github"]
}

resource "github_team_repository" "terraform-github-core" {
  team_id    = "${github_team.core.id}"
  repository = "${github_repository.terraform-github.name}"
  permission = "admin"
}

resource "github_team_repository" "terraform-github-community" {
  team_id    = "${github_team.community.id}"
  repository = "${github_repository.terraform-github.name}"
  permission = "push"
}

