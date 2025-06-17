if(pins::pin_exists(board, Sys.getenv("MODEL_CARD_NAME", "__undefined_model_card__"))) {
  card <- board |>
    pins::pin_download(Sys.getenv("MODEL_CARD_NAME")) |>
    readr::read_file()
} else 
{
  card <- NA
}

#* Get the model card.
#* @serializer html
#* @get /card
function() {
  card
}
