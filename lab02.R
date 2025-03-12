# anotações

library(tidyverse)
library(dados)

# dados_starwars

jabba <- dados_starwars |> 
  filter(massa > 1000)

dados_starwars |> 
  ggplot(aes(massa, altura)) +
  geom_point() +
  annotate(
    "label",
    x = jabba$massa,
    y = jabba$altura,
    label = jabba$nome,
    hjust = 1,
    vjust = -1
  )

# extensões do ggplot2

## gghighlight
library(gghighlight)
dados_starwars |> 
  ggplot(aes(massa, altura)) +
  geom_point() +
  gghighlight(
    massa > 1000 | altura > 210,
    label_key = nome
  )

library(ggrepel)
altos <- dados_starwars |> 
  filter(altura > 200)

dados_starwars |> 
  ggplot(aes(massa, altura)) +
  geom_point() +
  geom_label_repel(
    aes(label = nome),
    data = altos
  )

library(ggalt)

dados_starwars |> 
  ggplot(aes(massa, altura)) +
  geom_point() +
  geom_encircle(
    aes(label = nome),
    data = altos
  )

################# CORES ###################

# remotes::install_github("padsInsper/coresInsper")

coresInsper::cores_insper(30) |> 
  scales::show_col()

# -----------------------------------------

library(gganimate)

anim <- dados_gapminder |> 
  ggplot(aes(
    expectativa_de_vida, 
    log10(pib_per_capita), 
    size = log10(populacao),
    color = continente
  )) +
  geom_point() +
  facet_wrap(~continente) +
  labs(
    title = "Ano: {frame_time}",
    x = "Expectativa de vida",
    y = "log10(Pib per capita)"
  ) +
  transition_time(ano)

animate(
  anim,
  nframes = 40,
  duration = 10,
  start_pause = 2,
  end_pause = 2,
  width = 800,
  height = 600
)


# uso interessante

anim <- dados_gapminder |> 
  filter(continente == "Américas") |> 
  ggplot() +
  aes(expectativa_de_vida, log10(pib_per_capita), size = log10(populacao)) +
  geom_point() +
  gghighlight::gghighlight(
    pais %in% c("Brasil", "México"), 
    label_key = pais
  ) +
  theme_minimal(15) +
  # Aqui começa o gganimate
  labs(
    title = 'Ano: {frame_time}', 
    x = 'Expectativa de vida', 
    y = 'log10(Pib per capita)'
  ) +
  gganimate::transition_time(ano)


gganimate::animate(
  anim, 
  nframes = 40, 
  duration = 10, 
  start_pause = 2,
  end_pause = 2,
  width = 800, 
  height = 400
)


####


httr::GET(
  "https://test-api.cochrane.org/reviews?included=cancer"
)