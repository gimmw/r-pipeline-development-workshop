#' Create description for conformal split model
#'
#' @param model The conformalised model.
#'
#' @return The model description.
#' @export
vetiver_create_description.int_conformal_split <- function(model) {
  "A conformalised machine learning model."
}

#' Determine the vector data types.
#'
#' @param model The conformalised model.
#' @param ... Additional arguments.
#'
#' @return The vector data types.
#' @export
vetiver_ptype.int_conformal_split <- function(model, ...) {
  vctrs::vec_ptype(model$training)
}

#' Make predictions with the conformalised model.
#'
#' @param vetiver_model The conformalised model.
#' @param ... Additional arguments.
#'
#' @return The model predictions.
#' @export
handler_predict.int_conformal_split <- function(vetiver_model, ...) {
  ptype <- vetiver_model$prototype

  function(req) {
    newdata <- req$body
    newdata <- vetiver::vetiver_type_convert(newdata, ptype)
    newdata <- hardhat::scream(newdata, ptype)
    ret <- predict(vetiver_model$model, new_data = newdata, ...)
    list(.pred = ret)
  }
  
}

#' Create metadata for the conformalised model.
#'
#' @param model The conformalised model.
#' @param metadata The model metadata.
#'
#' @return Vetiver model metadata.
#' @export
vetiver_create_meta.int_conformal_split <- function(model, metadata) {
  vetiver::vetiver_meta(metadata, required_pkgs = "probably")
}