import numpy as np
import pandas as pd

from shiny import App, Inputs, Outputs, Session, reactive, render, ui

olist = pd.read_parquet(
  "https://github.com/padsInsper/202433-padsv/releases/download/dados/olist_items.parquet"
)

app_ui = ui.page_sidebar(
  ui.sidebar(
    "Controles e filtros"
  ),
  ui.layout_columns(
    # primeira linha
    ui.value_box(
      title="Média dos preços",
      value=ui.output_ui('media')
    ),
    ui.value_box(
      title="Título",
      value='123'
    ),
    ui.value_box(
      title="Título",
      value='123'
    ),
    # segunda linha
    ui.card(
      "Card 1"
    ),
    ui.card(
      "Card 2"
    ),
    # terceira linha
    ui.card(
      "Card 3"
    ),
    col_widths=[4,4,4,6,6,12],
    row_heights=[2,4,4],
    fillable=True
  ),
  fillable=True
)

def server(input: Inputs, output: Outputs, session: Session):
  
  @render.ui
  def media():
    minha_media = round(olist['price'].mean(), 2)
    return minha_media

app = App(app_ui, server)