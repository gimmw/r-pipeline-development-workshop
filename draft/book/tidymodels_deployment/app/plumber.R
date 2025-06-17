card <- board |>
  pin_download("stacks_ensemble_card") |>
  read_file()

#* Get the model card.
#* @serializer html
#* @get /card
function() {
  card
}