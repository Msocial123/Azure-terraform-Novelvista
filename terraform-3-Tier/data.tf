data "azurerm_resource_group" "existing" {
  name = var.resource_group_name
}

data "http" "my_ip" {
  url = "http://ifconfig.me"
}

# data.tf - REPLACE THE EXISTING CONTENT
/*
data "http" "my_ip" {
  url = "https://api.ipify.org?format=text"

  # Force plain text response
  request_headers = {
    Accept = "text/plain"
  }
}
*/

# Add a local to clean the response
locals {
  # Remove any HTML tags if present
  clean_ip = trimspace(
    replace(
      try(data.http.my_ip.response_body, "0.0.0.0"),
      "/<[^>]*>/",
      ""
    )
  )

  # Extract only IP address
  extracted_ip = try(
    regex("\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}", local.clean_ip)[0],
    "0.0.0.0"
  )

  my_public_ip = "${local.extracted_ip}/32"
}