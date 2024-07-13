variable "github_token" {
  description = "The OAuth token for GitHub API access."
  type        = string
}

variable "github_owner" {
  description = "The GitHub organization or user name."
  type        = string
}

variable "aws_access_key_id" {
  description = "AWS Access Key ID."
  type        = string
}

variable "aws_secret_access_key" {
  description = "AWS Secret Access Key."
  type        = string
}
