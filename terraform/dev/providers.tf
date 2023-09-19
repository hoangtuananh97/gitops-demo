provider "aws" {
  region = "ap-southeast-1"
  profile = "htuananh"
}
provider "aws" {
  alias  = "network"
  region = "ap-southeast-1"
  profile = "htuananh"
}
