output "policy_assignment_id" {
  value = [
    for policy_assignment in azurerm_management_group_policy_assignment.this : policy_assignment.id
  ]
}
