output "development" {
  description = "Development environment"
  value = {
    long_name  = "Development"
    code       = "dev"
    short_name = "d"
  }
}


output "test" {
  description = "Test environment"
  value = {
    long_name  = "Test"
    code       = "test"
    short_name = "t"
  }
}


output "production" {
  description = "Production environment"
  value = {
    long_name  = "Production"
    code       = "prod"
    short_name = "p"
  }
}


output "sandbox" {
  description = "Sandbox environment"
  value = {
    long_name  = "Sandbox"
    code       = "sbx"
    short_name = "s"
  }
}


output "quality_assurance" {
  description = "Quality assurance environment"
  value = {
    long_name  = "Quality assurance"
    code       = "qa"
    short_name = "q"
  }
}


output "user_acceptance_testing" {
  description = "User acceptance testing environment"
  value = {
    long_name  = "User acceptance testing"
    code       = "uat"
    short_name = "u"
  }
}
