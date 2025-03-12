import numpy as np
import pandas as pd

from shiny import App, Inputs, Outputs, Session, reactive, render, ui

olist = pd.read_parquet(
  "https://github.com/padsInsper/202433-padsv/releases/download/dados/olist_items.parquet"
)

app_ui = ui.page_sidebar(
  ui.sidebar(
    # inputs
    "Controles e filtros"
  ),
  ui.layout_columns(
    ui.value_box(
      "Título",
      ui.output_ui("media"),
      "Detalhe",
      theme="bg-gradient-orange-red"
    ),
    ui.value_box(
      "Título",
      ui.output_ui("algo"),
      "Detalhe",
      theme="bg-gradient-orange-blue"
    ),
    ui.value_box(
      "Título",
      ui.output_ui("nada"),
      "Detalhe",
      theme="bg-gradient-orange-green"
    ),
    ui.value_box(
      "Título",
      ui.output_ui("tudo"),
      "Detalhe",
      theme="bg-gradient-orange-purple"
    ),
    ui.card(
      "oi",
      fillable=True
    ),
    ui.card(
      "tudo",
      fillable=True
    ),
    ui.card(
      "bem",
      fillable=True
    ),
    col_widths=[3, 3, 3, 3, 12, 6, 6],
    row_heights=[2, 4, 4],
    fillable=True
  ),
  title='Análise de dados',
  fillable=True
)


def server(input: Inputs, output: Outputs, session: Session):
    
  @render.ui
  def media():
    return round(olist['price'].mean(), 2)
      
app = App(app_ui, server)
