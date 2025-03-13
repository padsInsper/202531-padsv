import numpy as np
import pandas as pd

from shiny import App, Inputs, Outputs, Session, reactive, render, ui
from shinywidgets import output_widget, render_widget  

import plotly.express as px

olist = pd.read_parquet(
  "https://github.com/padsInsper/202433-padsv/releases/download/dados/olist_items.parquet"
)

estados = olist['geolocation_state_seller'].unique().tolist()

app_ui = ui.page_sidebar(
  ui.sidebar(
    # inputs
    "Controles e filtros",
    ui.input_select("seller_state", "Seller state", choices=estados, selected="SP"),
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
      "Detalhe"
    ),
    ui.value_box(
      "Título",
      ui.output_ui("nada"),
      "Detalhe"
    ),
    ui.value_box(
      "Título",
      ui.output_ui("tudo"),
      "Detalhe"
    ),
    output_widget("plot"),
    ui.card(
      "tudo"
    ),
    ui.card(
      "bem"
    ),
    col_widths=[3, 3, 3, 3, 12, 6, 6],
    row_heights=[2, 4, 4],
    fillable=True
  ),
  title='Análise de dados',
  fillable=True
)


def server(input: Inputs, output: Outputs, session: Session):
  
  @reactive.calc
  def filtro():
    return olist[olist['geolocation_state_seller'] == input.seller_state()].copy()

  @render.ui
  def media():
    olist_filtrada = filtro()
    return round(olist_filtrada['price'].mean(), 2)
  
  @render_widget  
  def plot():
    olist_filtrada = filtro()
    olist_filtrada['lprice'] = np.log(olist_filtrada['price'])
    fig = px.histogram(
        data_frame=olist_filtrada, x="lprice", nbins=50
    ).update_layout(
        yaxis_title="Count",
        xaxis_title="Price",
    )
    return fig
      
app = App(app_ui, server)
