variable "email" {
  type    = string
  default = "abdulwahidh2005@gmail.com"

}

variable "teams_workflow_webhook_url" {
  description = "Fresh Teams Workflow webhook URL. Store in an ignored tfvars file or TF_VAR_teams_workflow_webhook_url; rotate the previously exposed URL."
  type        = string
  sensitive   = true
  default     = "https://default10ed0bc931bd43519ba91a0a46700b.ee.environment.api.powerplatform.com:443/powerautomate/automations/direct/cu/23/workflows/f65dd7f06d894f5593782e697d5fa830/triggers/manual/paths/invoke?api-version=1&sp=%2Ftriggers%2Fmanual%2Frun&sv=1.0&sig=rR3LcLFpZnUXWvm9bASfM4rdAVy8-rg26mTTzFRchs0"
}
