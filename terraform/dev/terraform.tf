terraform {
  cloud {
    hostname     = "app.terraform.io"
    organization = "bumbii_org"
    workspaces {
      name = "Bumbii_NonProd"
    }
  }
}
