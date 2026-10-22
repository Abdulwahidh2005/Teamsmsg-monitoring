variable "email" {
  type    = string
  default = "abdulwahidh2005@gmail.com"

}

variable "teams_workflow_webhook_url" {
  description = "Fresh Teams Workflow webhook URL. Store in an ignored tfvars file or TF_VAR_teams_workflow_webhook_url; rotate the previously exposed URL."
  type        = string
  sensitive   = true
}
