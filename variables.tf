variable "name" {
  type        = string
  description = "(optional) Specify the name. Default: random name"
  default     = null
}
variable "pipeline_arn" {
  type        = string
  description = "Codepipline ARN that will be triggered"
}
variable "repo_arn" {
  type        = string
  description = "Codecommit repo to attach the pipeline with"
}
variable "branch_name" {
  type        = string
  description = "(Optional) Branch name to trigger pipeline for. Default: main"
  default     = "main"
}
