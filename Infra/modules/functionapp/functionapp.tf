data "azurerm_storage_account" "st" {
  name = var.st_name
  resource_group_name = var.rg_name 
}

data "azurerm_application_insights" "appins" {
  name = var.appinsghts_name
  resource_group_name = var.rg_name
}

resource "azurerm_windows_function_app" "functionapp" {
  name = var.func_name
  location = var.location
  resource_group_name = var.rg_name
  service_plan_id = data.azurerm_service_plan.appplan.id
  identity {
    type = "SystemAssigned"
  }
  https_only = true
  tags = { 
    environment = var.env
  }
  storage_account_access_key = data.azurerm_storage_account.st.primary_access_key
  storage_account_name = data.azurerm_storage_account.st.name
  site_config {}
  app_settings = {
    name = "appsettings"
    applicationInsightResourceId = data.azurerm_application_insights.appins.id
    FUNCTIONS_WORKER_RUNTIME = "dotnet-isolated"
    retainCurrentAppSettings: true
    FUNCTIONS_EXTENSION_VERSION: "~4"
    AzureFunctionsWebHost__hostid = data.azurerm_storage_account.st.name
    AzureWebJobsStorage = data.azurerm_storage_account.st.primary_access_key
    WEBSITE_HEALTHCHECK_MAXPINGFAILURES = 10 
  }
}
