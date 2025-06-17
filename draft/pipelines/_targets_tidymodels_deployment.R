box::use(
  here[here],
  targets[tar_target, tar_source],
  readr[read_csv],
  dplyr[select],
  pins[board_s3, pin_upload],
  vetiver[vetiver_model, vetiver_pin_write]
)

options(box.path = here())

box::use(R/tidymodels_deployment)

tar_source(here("R"))

list(
  tar_target(
    mtcars, read_csv("https://raw.githubusercontent.com/plotly/datasets/refs/heads/master/mtcars.csv") |>
      select(-manufacturer)
  ),
  tar_target(
    data_split, tidymodels_deployment$get_split(mtcars)
  ),
  tar_target(
    data_train, data_split$train
  ),
  tar_target(
    data_test, data_split$test
  ),
  tar_target(
    training_recipe, tidymodels_deployment$get_training_recipe(data_train)
  ),
  tar_target(
    model_set_data, tidymodels_deployment$get_workflow_set(data_train, training_recipe)
  ),
  tar_target(
    tuned_model_set, tidymodels_deployment$optimise_hyperparams(
      model_set_data$model_set, 
      model_set_data$lr_recipe, 
      model_set_data$rf_recipe, 
      model_set_data$svm_recipe
    )
  ),
  tar_target(
    stack_reg, tidymodels_deployment$stack_model_set(tuned_model_set)
  ),
  tar_target(
    patched_stack_reg, tidymodels_deployment$patch_tidymodel(stack_reg, training_recipe, data_train)
  ),
  tar_target(
    conformalised_stack, tidymodels_deployment$conformalise_model(patched_stack_reg, data_train)
  ),
  tar_target(
    board, board_s3(
      "data", 
      access_key = "user", 
      secret_access_key = "password", 
      region = "us-east-2",
      endpoint = "https://minio-api.pfram.k8s.dev.pfr.co.nz"
    )
  ),
  tar_target(
    v_conformalised_stack, vetiver_model(conformalised_stack, "conformalised_stack")
  ),
  
  tar_target(
    pinned_model, board |> vetiver_pin_write(v_conformalised_stack)
  ),
  tar_target(
    pinned_card, board |> 
      pin_upload(
        here("book", "tidymodels_deployment", "card.html"), 
        "stacks_ensemble_card"
      )
  )
)
