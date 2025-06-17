library(workflows)
library(workflowsets)
library(h2o)
library(stacks)
library(probably)

source(file.path("/app", "api", "R", "vetiver_integration.R"))

h2o_endpoint <- Sys.getenv("H2O_ENDPOINT")
if(h2o_endpoint != "") {
  h2o::h2o.connect(
    ip = h2o_endpoint, 
    port = 443, 
    https = TRUE
  )
}

board <- pins::board_s3(
  Sys.getenv("S3_BUCKET", "data"), 
  access_key = Sys.getenv("AWS_ACCESS_KEY_ID", "user"), 
  secret_access_key = Sys.getenv("AWS_SECRET_ACCESS_KEY", "password"), 
  region = "us-east-2",
  endpoint = Sys.getenv("S3_ENDPOINT_URL")
)

loaded_v <- board |> 
  vetiver::vetiver_pin_read(Sys.getenv("MODEL_NAME"))

plumber::pr(file.path("/app", "api", "plumber.R")) |>
  vetiver::vetiver_api(loaded_v) |>
  plumber::pr_run(
    host = "0.0.0.0", 
    port = as.integer(Sys.getenv("MODEL_PORT", 8088)),
    debug = TRUE
  )
