resource "azurerm_logic_app_workflow" "teams_alerts" {
  name                = "teams-alerts-workflow"
  location            = azurerm_resource_group.app_rg.location
  resource_group_name = azurerm_resource_group.app_rg.name
}

resource "azurerm_logic_app_trigger_http_request" "alert" {
  name         = "azure_monitor_alert"
  logic_app_id = azurerm_logic_app_workflow.teams_alerts.id

  schema = <<SCHEMA
{
  "type": "object",
  "properties": {
    "schemaId": { "type": "string" },
    "data": {
      "type": "object",
      "properties": {
        "essentials": {
          "type": "object",
          "properties": {
            "alertId": { "type": "string" },
            "alertRule": { "type": "string" },
            "severity": { "type": "string" },
            "signalType": { "type": "string" },
            "monitorCondition": { "type": "string" },
            "monitoringService": { "type": "string" },
            "alertTargetIDs": {
              "type": "array",
              "items": { "type": "string" }
            },
            "originAlertId": { "type": "string" },
            "firedDateTime": { "type": "string" },
            "resolvedDateTime": { "type": "string" },
            "description": { "type": "string" },
            "essentialsVersion": { "type": "string" },
            "alertContextVersion": { "type": "string" }
          }
        },
        "alertContext": {
          "type": "object",
          "properties": {}
        }
      }
    }
  }
}
SCHEMA
}

resource "azurerm_logic_app_action_custom" "post_alert_to_teams" {
  # Use a new action name while Terraform replaces the old HTTP action.
  name         = "post-alert-to-teams-v2"
  logic_app_id = azurerm_logic_app_workflow.teams_alerts.id

  body = jsonencode({
    type = "Http"
    inputs = {
      method = "POST"
      uri    = var.teams_workflow_webhook_url

      headers = {
        "Content-Type" = "application/json"
      }

      body = {
        # The Teams Workflow webhook trigger expects the Adaptive Card itself
        # as the request body, not a Bot Framework { type = "message", attachments = [...] } envelope.
        "$schema" = "http://adaptivecards.io/schemas/adaptive-card.json"
        type      = "AdaptiveCard"
        version   = "1.2"

        body = [
          {
            type   = "TextBlock"
            text   = "Azure Monitor alert"
            weight = "Bolder"
            size   = "Medium"
          },
          {
            type = "FactSet"
            facts = [
              {
                title = "Rule"
                value = "@{triggerBody()?['data']?['essentials']?['alertRule']}"
              },
              {
                title = "Severity"
                value = "@{triggerBody()?['data']?['essentials']?['severity']}"
              },
              {
                title = "Condition"
                value = "@{triggerBody()?['data']?['essentials']?['monitorCondition']}"
              },
              {
                title = "Description"
                value = "@{triggerBody()?['data']?['essentials']?['description']}"
              }
            ]
          }
        ]
      }
    }
    runAfter = {}
  })

  depends_on = [
    azurerm_logic_app_trigger_http_request.alert
  ]
}
