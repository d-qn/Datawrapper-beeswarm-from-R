library(beeswarm)
library(tidyverse)
library(DatawRappr)

### 1. Load data

# These are real data from Switzerland's federal ballot 
# on the 3rd of March 2024 regarding the 13th pension, results by municipality
ddd <- read_csv("https://gist.githubusercontent.com/d-qn/5cff401873518297fb029b3e3fe1b836/raw/9e930fa5739215eaea969fd72fb231e3461b9318/bs_13rente_muni.csv")


### 2. Compute/plot the beeswarwm

# Beeswarm of the % yes vote, `qValue`, by language region ,`value`.
# - There is a hack here to assign the id of the data `qId` to the color, 
# this will allow to join the computed beeswarm coordindates to the original data
# - This hack is only useful to get more data to populate datawrapper's tooltip
# - In addition with getting the beeswarm coordinates, this will plot the beeswarm
# - Adjust the "cex" parameter to change the size of the points

df_bees <- beeswarm(
  qValue ~ value,
  data = ddd ,
  method = "compactswarm",
  pwcol = qId,
  cex =.4,
  pch = 16, vertical = F
)

rownames(df_bees) <- NULL

### 3. Join the computed beeswarm coordinates to the original data
# - Optional step, this is only to get more data for datawrapper's tooltip

dfb <- left_join(
  df_bees %>% select(x,y, x.orig, y.orig, col),
  ddd %>% 
    mutate(value = as.character(value)), 
  by = c("col" = "qId")
) 


### 4. Optional - Send the data to Datawrapper via its API or manually upload it
dfb %>% 
  dw_data_to_chart("74ZFo", api_key = XX) # replace XX with your API key and datawrapper chart ID

# or
dfb %>% write_csv("beeswarm_data4datwwrapper.csv")


### 5. In datawrapper 
# (a. Upload the data)
# b. Create a scatter plot
# c. Assign the y column to the horizontal axis, x column to the vertical axis, see the screenshot "datawrapper_screenshot.png"
# d. Tweak & enjoy

