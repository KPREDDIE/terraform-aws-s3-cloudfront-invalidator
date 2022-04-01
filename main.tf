provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Name       = var.tag_Name
      sitecode   = var.tag_sitecode
      department = var.tag_department
      team       = var.tag_team
      tier       = var.tag_tier
      costcenter = var.tag_costcenter
    }
  }
}
