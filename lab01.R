
library(tidyverse)
olist <- readr::read_rds("data-raw/rds/olist_items.rds")

base_para_grafico <- olist |> 
  count(types) |>
  filter(n > 100) |> 
  mutate(types = fct_reorder(types, n))

base_para_grafico |> 
  ggplot(aes(x = n/1000, y = types)) +
  geom_col(
    fill = "#8ae3d7",
    width = 0.5
  ) +
  geom_label(
    aes(
      x = n / 1000 / 2, 
      label = round(n / 1000, 2)
    )
  ) +
  theme_dark() +
  labs(
    x = "Quantidade\n(milhares)",
    y = "Forma de pagamento",
    title = "Formas de pagamento mais comuns",
    subtitle = "Considerando os tipos com mais de 100 observações",
    caption = "Fonte: Olist"
  ) +
  theme(
    text = element_text(family = "serif"),
    plot.background = element_rect(fill = "black"),
    axis.text = element_text(colour = "white"),
    axis.title = element_text(colour = "white"),
    plot.title = element_text(colour = "white"),
    plot.subtitle = element_text(colour = "white")
  )


dplyr::glimpse(olist)


data = as.Date("2023-05-27")

floor_date(data, "month")

base_plot <- olist |> 
  mutate(
    data = as.Date(order_purchase_timestamp),
    data = floor_date(data, "month"),
    estado = fct_other(
      seller_state,
      keep = c("SP", "RJ"),
      other_level = "Outros"
    ),
    estado = ifelse(
      seller_state %in% c("SP", "RJ"), seller_state, "Outros"
    )
  ) |> 
  filter(
    data >= "2017-01-01",
    data <= "2018-07-01"
  ) |> 
  count(data, estado)

base_plot |> 
  ggplot(aes(x = data, y = n, colour = estado)) +
  geom_line(linewidth = 2) +
  labs(
    x = "Data",
    y = "Quantidade",
    title = "São Paulo tem mais vendas",
    subtitle = "O que é esperado, pois a população é maior 😬",
    caption = "Fonte: Olist",
    colour = "Estado"
  ) +
  scale_x_date(
    date_breaks = "3 month",
    date_labels = "%b\n%Y"
  ) +
  scale_colour_viridis_d(begin = .2, end = .8) +
  theme_light() +
  theme(
    legend.position = "bottom"
  )

# Gráfico 3:

# COLUNAS: price, product_category_name

olist_filtrada <- olist |> 
  group_by(product_category_name) |> 
  filter(n() > 4000) |> 
  ungroup()

?stat_density_ridges

olist_filtrada |> 
  ggplot(aes(x = price, y = product_category_name)) +
  ggridges::geom_density_ridges(
    na.rm = FALSE,
    n = 2048
  ) +
  coord_cartesian(
    xlim = c(0, 300)
  )
