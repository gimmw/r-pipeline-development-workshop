ui <- page_sidebar(
  title = "Dashboard",
  
  theme = bs_theme(
    bootswatch = "lux",
    base_font = font_google("Inter"),
    navbar_bg = "#4a8273",
    font_scale = 0.8
  ),
  
  sidebar = sidebar(
    bg = "white",
    accordion(
      accordion_panel(
        "Inputs",
        radioButtons(
          "dataset", 
          tooltip(
            span("Dataset", bsicons::bs_icon("question-circle-fill")),
            "Select explanatory and response variables for a dataset.",
            placement = "left"
          ),
          dataset_choices,
          inline = TRUE
        ),
        selectInput(
          "x_col",
          "X column",
          character(0),
          selectize = TRUE
        ),
        selectInput(
          "y_col",
          "Y column",
          character(0),
          multiple = FALSE,
          selectize = TRUE
        )
      ),
      accordion_panel(
        "File Management",
        actionButton("download_data", "Download Dataset")
      )
    )
  ),
  
  navset_card_underline(
    title = "Outputs",
    nav_panel(
      "Plot", 
      card(
        plotlyOutput("plot"),
        full_screen = TRUE
      )
    ),
    nav_panel(
      "Summary", 
      card(
        dataTableOutput("summary"),
        full_screen = TRUE
      )
    ),
    nav_panel(
      "Data Table", 
      card(
        dataTableOutput("table"),
        full_screen = TRUE
      )
    ),
    nav_panel(
      "Histograms", 
      layout_columns(
        card(
          plotlyOutput("histogram_x"),
          full_screen = TRUE
        ),
        card(
          plotlyOutput("histogram_y"),
          full_screen = TRUE
        )
      )
    )
  )
)  