---
title: 'Weekly Exercises #4'
author: "Xinyi Wang"
output: 
  html_document:
    keep_md: TRUE
    toc: TRUE
    toc_float: TRUE
    df_print: paged
    code_download: true
---


```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE, error=TRUE, message=FALSE, warning=FALSE)
```

```{r libraries}
library(tidyverse)     # for data cleaning and plotting
library(googlesheets4) # for reading googlesheet data
library(lubridate)     # for date manipulation
library(openintro)     # for the abbr2state() function
library(palmerpenguins)# for Palmer penguin data
library(maps)          # for map data
library(ggmap)         # for mapping points on maps
library(gplots)        # for col2hex() function
library(RColorBrewer)  # for color palettes
library(sf)            # for working with spatial data
library(leaflet)       # for highly customizable mapping
library(carData)       # for Minneapolis police stops data
library(ggthemes)      # for more themes (including theme_map())
gs4_deauth()           # To not have to authorize each time you knit.
theme_set(theme_minimal())
```

```{r data}
# Starbucks locations
Starbucks <- read_csv("https://www.macalester.edu/~ajohns24/Data/Starbucks.csv")

starbucks_us_by_state <- Starbucks %>% 
  filter(Country == "US") %>% 
  count(`State/Province`) %>% 
  mutate(state_name = str_to_lower(abbr2state(`State/Province`))) 

# Lisa's favorite St. Paul places - example for you to create your own data
favorite_stp_by_lisa <- tibble(
  place = c("Home", "Macalester College", "Adams Spanish Immersion", 
            "Spirit Gymnastics", "Bama & Bapa", "Now Bikes",
            "Dance Spectrum", "Pizza Luce", "Brunson's"),
  long = c(-93.1405743, -93.1712321, -93.1451796, 
           -93.1650563, -93.1542883, -93.1696608, 
           -93.1393172, -93.1524256, -93.0753863),
  lat = c(44.950576, 44.9378965, 44.9237914,
          44.9654609, 44.9295072, 44.9436813, 
          44.9399922, 44.9468848, 44.9700727)
  )

#COVID-19 data from the New York Times
covid19 <- read_csv("https://raw.githubusercontent.com/nytimes/covid-19-data/master/us-states.csv")

```

## Put your homework on GitHub!

If you were not able to get set up on GitHub last week, go [here](https://github.com/llendway/github_for_collaboration/blob/master/github_for_collaboration.md) and get set up first. Then, do the following (if you get stuck on a step, don't worry, I will help! You can always get started on the homework and we can figure out the GitHub piece later):

* Create a repository on GitHub, giving it a nice name so you know it is for the 4th weekly exercise assignment (follow the instructions in the document/video).  
* Copy the repo name so you can clone it to your computer. In R Studio, go to file --> New project --> Version control --> Git and follow the instructions from the document/video.  
* Download the code from this document and save it in the repository folder/project on your computer.  
* In R Studio, you should then see the .Rmd file in the upper right corner in the Git tab (along with the .Rproj file and probably .gitignore).  
* Check all the boxes of the files in the Git tab under Stage and choose commit.  
* In the commit window, write a commit message, something like "Initial upload" would be appropriate, and commit the files.  
* Either click the green up arrow in the commit window or close the commit window and click the green up arrow in the Git tab to push your changes to GitHub.  
* Refresh your GitHub page (online) and make sure the new documents have been pushed out.  
* Back in R Studio, knit the .Rmd file. When you do that, you should have two (as long as you didn't make any changes to the .Rmd file, in which case you might have three) files show up in the Git tab - an .html file and an .md file. The .md file is something we haven't seen before and is here because I included `keep_md: TRUE` in the YAML heading. The .md file is a markdown (NOT R Markdown) file that is an interim step to creating the html file. They are displayed fairly nicely in GitHub, so we want to keep it and look at it there. Click the boxes next to these two files, commit changes (remember to include a commit message), and push them (green up arrow).  
* As you work through your homework, save and commit often, push changes occasionally (maybe after you feel finished with an exercise?), and go check to see what the .md file looks like on GitHub.  
* If you have issues, let me know! This is new to many of you and may not be intuitive at first. But, I promise, you'll get the hang of it! 


## Instructions

* Put your name at the top of the document. 

* **For ALL graphs, you should include appropriate labels.** 

* Feel free to change the default theme, which I currently have set to `theme_minimal()`. 

* Use good coding practice. Read the short sections on good code with [pipes](https://style.tidyverse.org/pipes.html) and [ggplot2](https://style.tidyverse.org/ggplot2.html). **This is part of your grade!**

* When you are finished with ALL the exercises, uncomment the options at the top so your document looks nicer. Don't do it before then, or else you might miss some important warnings and messages.


## Warm-up exercises from tutorial

These exercises will reiterate what you learned in the "Mapping data with R" tutorial. If you haven't gone through the tutorial yet, you should do that first.

### Starbucks locations (`ggmap`)

  1. Add the `Starbucks` locations to a world map. Add an aesthetic to the world map that sets the color of the points according to the ownership type. What, if anything, can you deduce from this visualization? 

```{r}
world <- get_stamenmap(
    bbox = c(left = -180, bottom = -57, right = 179, top = 82.1), 
    maptype = "terrain",
    zoom = 2)

ggmap(world) +
  geom_point(data = Starbucks, 
             aes(x = Longitude, y = Latitude, color= `Ownership Type`),
             alpha = .5, 
             size = 1) +
  labs(title = "World Starbuck location")+
  theme_map()
```
  

  2. Construct a new map of Starbucks locations in the Twin Cities metro area (approximately the 5 county metro area).  
```{r}
Twincity <- get_stamenmap(
    bbox = c(left = -93.2857, bottom = 44.9226, right = -93.0793, top = 44.9867), 
    maptype = "terrain",
    zoom = 12)

ggmap(Twincity) +
  geom_point(data = Starbucks, 
             aes(x = Longitude, y = Latitude),
             alpha = .5, 
             size = 3) +
  labs(title="Starbuck location in Twin Cities Metro")+
  theme_map()


```

  3. In the Twin Cities plot, play with the zoom number. What does it do?  (just describe what it does - don't actually include more than one map).  
  
  If the zoom is larger, it means that there would be more details in the grapg, if the zoom number is smaller, it means that there will be less details in the graph.
  
  4. Try a couple different map types (see `get_stamenmap()` in help and look at `maptype`). Include a map with one of the other map types.  
```{r}
world1 <- get_stamenmap(
    bbox = c(left = -180, bottom = -57, right = 179, top = 82.1), 
    maptype = "terrain",
    zoom = 2)

ggmap(world1) +
  geom_point(data = Starbucks, 
             aes(x = Longitude, y = Latitude, color= `Ownership Type`),
             alpha = .3, 
             size = 1) +
  labs(title = "World Starbuck location")+
  theme_map()

world2 <- get_stamenmap(
    bbox = c(left = -180, bottom = -57, right = 179, top = 82.1), 
    maptype = "watercolor",
    zoom = 2)

ggmap(world2) +
  geom_point(data = Starbucks, 
             aes(x = Longitude, y = Latitude, color= `Ownership Type`),
             alpha = .3, 
             size = 1) +
  labs(title = "World Starbuck location")+
  theme_map()


```

  5. Add a point to the map that indicates Macalester College and label it appropriately. There are many ways you can do think, but I think it's easiest with the `annotate()` function (see `ggplot2` cheatsheet).
```{r}
Twincity <- get_stamenmap(
    bbox = c(left = -93.2857, bottom = 44.9226, right = -93.0793, top = 44.9867), 
    maptype = "terrain",
    zoom = 12)

ggmap(Twincity) +
  annotate('segment',x=-93.1693,xend=-93.1693,y=44.9378,yend=44.9378,color=I('red'),arrow=arrow(length=unit(0.1,"cm")),size=1.5)+
  annotate('text',x=-93.1693,y=44.9478,label="Macalester College",color=I('red'),size=8)+
  ggtitle("Where is Macalester College?")
```
  

### Choropleth maps with Starbucks data (`geom_map()`)

The example I showed in the tutorial did not account for population of each state in the map. In the code below, a new variable is created, `starbucks_per_10000`, that gives the number of Starbucks per 10,000 people. It is in the `starbucks_with_2018_pop_est` dataset.

```{r}
census_pop_est_2018 <- read_csv("https://www.dropbox.com/s/6txwv3b4ng7pepe/us_census_2018_state_pop_est.csv?dl=1") %>% 
  separate(state, into = c("dot","state"), extra = "merge") %>% 
  select(-dot) %>% 
  mutate(state = str_to_lower(state))

starbucks_with_2018_pop_est <-
  starbucks_us_by_state %>% 
  left_join(census_pop_est_2018,
            by = c("state_name" = "state")) %>% 
  mutate(starbucks_per_10000 = (n/est_pop_2018)*10000)
```

  6. **`dplyr` review**: Look through the code above and describe what each line of code does.
  
  census_pop_est_2018 <- read_csv("https://www.dropbox.com/s/6txwv3b4ng7pepe/us_census_2018_state_pop_est.csv?dl=1"):read in the census population data.
  separate(state, into = c("dot","state"), extra = "merge")：because there is a . before each state so this command get rid of the dot and state to give us the exact name for each state. And if the seperator is a character,extra="merge" makes sue that it only splits at most length(into) times.
  select(-dot): means to choose everything except the dot.
  mutate(state = str_to_lower(state)): makes all the letters in state to be lower case.
  
  starbucks_with_2018_pop_est <-:create a new dataset called starbucks_with_2018_pop_est.
  starbucks_us_by_state: using starbucks_us_by_state as a starting point.
  left_join(census_pop_est_2018,by = c("state_name" = "state")):join census_pop_est_2018 to starbucks_us_by_state if the state_name in starbucks_us_by_state matches the state in census_pop_est_2018.
  mutate(starbucks_per_10000 = (n/est_pop_2018)*10000):create a new variable called starbucks_per_10000 that gives the number of Starbucks per 10,000 people.
  
  7. Create a choropleth map that shows the number of Starbucks per 10,000 people on a map of the US. Use a new fill color, add points for all Starbucks in the US (except Hawaii and Alaska), add an informative title for the plot, and include a caption that says who created the plot (you!). Make a conclusion about what you observe.

  **I notice that Starbucks per 10,000 people tends to be larger around the west and east border, and it is especially high in CA.**
  
```{r}
states_map <- map_data("state")

starbucks_with_2018_pop_est %>% 
  ggplot() +
  geom_map(map = states_map,
           aes(map_id = state_name,
               fill = n)) +
  geom_point(data = Starbucks %>% filter(Country=="US",!`State/Province` %in% c("AK","HI")),
             aes(x = Longitude, y = Latitude),
             size = .05,
             alpha = .2, 
             color = "black") +
  expand_limits(x = states_map$long, y = states_map$lat) + 
  labs(title="the number of Starbucks per 10,000 people in US",
       caption = "graph:@XinyiWang")+
  scale_fill_gradient(low="orange", high="red")
  theme_map()
```

### A few of your favorite things (`leaflet`)

  8. In this exercise, you are going to create a single map of some of your favorite places! The end result will be one map that satisfies the criteria below. 

  * Create a data set using the `tibble()` function that has 10-15 rows of your favorite places. The columns will be the name of the location, the latitude, the longitude, and a column that indicates if it is in your top 3 favorite locations or not. For an example of how to use `tibble()`, look at the `favorite_stp_by_lisa` I created in the data R code chunk at the beginning.  

  * Create a `leaflet` map that uses circles to indicate your favorite places. Label them with the name of the place. Choose the base map you like best. Color your 3 favorite places differently than the ones that are not in your top 3 (HINT: `colorFactor()`). Add a legend that explains what the colors mean.  
  
  * Connect all your locations together with a line in a meaningful way (you may need to order them differently in the original data).  
  
  * If there are other variables you want to add that could enhance your plot, do that now. 
  
  **I am connecting my locations from the most north-west to the most east and then to the most south-west, which give me a sense of the border of the area that I am visiting. I am also having the places near school in the middle because having them in the middle will give a sense of starting the route from school to the places, which is usually the route that I go.**
  
```{r}
favorite_stp_by_Xinyi <- tibble(
  place = c( "Tea House Chinese","Macalester College", "Sencha Tea bar", 
            "CVS", "Cafe Latte", "Trader Joe's",
            "Whole Foods", "Texas Roadhouse","Minnehaha Regional Park","Mall of America"),
  long = c( -93.221423,-93.1712321, -93.172062, 
           -93.176257, -93.136284, -93.146140, 
           -93.166423, -92.933219,-93.211010,-93.240544),
  lat = c(44.973904, 44.9378965, 44.939985,
          44.940562, 44.939970, 44.927211, 
          44.947150, 44.945683,44.916346,44.863875),
  fav_three=c("No,it's not my favorite 3","Yes, it's my favorite 3","Yes, it's my favorite 3","No,it's not my favorite 3","Yes, it's my favorite 3","No,it's not my favorite 3","No,it's not my favorite 3","No,it's not my favorite 3","No,it's not my favorite 3","No,it's not my favorite 3")
  )

pal <- colorFactor(palette = c("blue", "red"),domain = favorite_stp_by_Xinyi$fav_three)

leaflet(data = favorite_stp_by_Xinyi) %>% 
  addTiles() %>% 
  addCircles(lng = ~long, 
             lat = ~lat, 
             label = ~place, 
             weight = 10, 
             opacity = 1, 
             color = ~pal(fav_three)) %>% 
  addPolylines(lng = ~long, 
               lat = ~lat, 
               popup = ~paste(place),
               color = col2hex("darkred"))%>%
  addLegend(pal = pal, 
            values = ~fav_three, 
            opacity = 0.5, 
            title = NULL,
            position = "bottomright") 

```
  
## Revisiting old datasets

This section will revisit some datasets we have used previously and bring in a mapping component. 

### Bicycle-Use Patterns

The data come from Washington, DC and cover the last quarter of 2014.

Two data tables are available:

- `Trips` contains records of individual rentals
- `Stations` gives the locations of the bike rental stations

Here is the code to read in the data. We do this a little differently than usualy, which is why it is included here rather than at the top of this file. To avoid repeatedly re-reading the files, start the data import chunk with `{r cache = TRUE}` rather than the usual `{r}`. This code reads in the large dataset right away.

```{r cache=TRUE}
data_site <- 
  "https://www.macalester.edu/~dshuman1/data/112/2014-Q4-Trips-History-Data.rds" 
Trips <- readRDS(gzcon(url(data_site)))
Stations<-read_csv("http://www.macalester.edu/~dshuman1/data/112/DC-Stations.csv")
```

  9. Use the latitude and longitude variables in `Stations` to make a visualization of the total number of departures from each station in the `Trips` data. Use either color or size to show the variation in number of departures. This time, plot the points on top of a map. Use any of the mapping tools you'd like.
  
```{r}
Station_Departures<-Trips %>%
  group_by(sstation)%>%
  summarise(departures=n())%>%
  full_join(Stations,by=c("sstation"="name")) %>% 
  select(sstation,lat,long)

stations <- get_stamenmap(bbox = c(left = -77.25, bottom = 38.75, right = -76.75, top = 39.2),maptype = "toner-hybrid", zoom = 10)

ggmap(stations)+
  geom_point(data=Station_Departures,aes(x=long,y=lat))+
  scale_color_gradient()
```
  
  10. Only 14.4% of the trips in our data are carried out by casual users. Create a plot that shows which area(s) have stations with a much higher percentage of departures by casual users. What patterns do you notice? Also plot this on top of a map. I think it will be more clear what the patterns are.
  
  **I notice that most bike users are centered at flat areas**
  
```{r}
(casual_avg<-mean(Trips$client=="Casual"))

Commuters<-Trips %>%
  group_by(sstation,client) %>%
  summarise(departures=n()) %>%
  spread(key=client,value=departures,fill=0) %>%
  filter((Registered+Casual)>=20) %>%
  mutate(perc_casual_net=Casual/(Registered+Casual)-casual_avg) %>%
  left_join(Stations,by=c("sstation"="name")) %>% 
  select(sstation,lat,long, perc_casual_net)

ggmap(stations)+
  geom_point(data=Commuters,aes(x=long,y=lat,size=perc_casual_net,color=perc_casual_net))+
  scale_color_gradient()

```
  
### COVID-19 data

The following exercises will use the COVID-19 data from the NYT.

  11. Create a map that colors the states by the most recent cumulative number of COVID-19 cases (remember, these data report cumulative numbers so you don't need to compute that). Describe what you see. What is the problem with this map?
  
  **I notice that the cases number are larger around west and south border and NY. The problem is that the scaler for the cases numbers are in e, which is not that intuitive**
  
```{r}
states_map <- map_data("state")

covid_by_state <- covid19 %>% 
  group_by(state)%>%
  filter(date==max(date))%>%
  mutate(state_name = str_to_lower(state))
  

covid_by_state %>% 
  ggplot() +
  geom_map(map = states_map,
           aes(map_id = state_name,
               fill = cases)) +
  expand_limits(x = states_map$long, y = states_map$lat) + 
  theme_map()
```
  
  12. Now add the population of each state to the dataset and color the states by most recent cumulative cases/10,000 people. See the code for doing this with the Starbucks data. You will need to make some modifications. 
  
```{r}
census_pop_est_2018 <- read_csv("https://www.dropbox.com/s/6txwv3b4ng7pepe/us_census_2018_state_pop_est.csv?dl=1") %>% 
  separate(state, into = c("dot","state"), extra = "merge") %>% 
  select(-dot) %>% 
  mutate(state = str_to_lower(state))

covid_with_2018_pop_est <-
  covid_by_state %>% 
  left_join(census_pop_est_2018,
            by = c("state_name" = "state")) %>% 
  mutate(cases_per_10000 = (cases/est_pop_2018)*10000)

covid_with_2018_pop_est %>% 
  ggplot() +
  geom_map(map = states_map,
           aes(map_id = state_name,
               fill = cases_per_10000)) +
  expand_limits(x = states_map$long, y = states_map$lat) + 
  theme_map()
```
  
  13. **CHALLENGE** Choose 4 dates spread over the time period of the data and create the same map as in exercise 12 for each of the dates. Display the four graphs together using faceting. What do you notice?
  
  **Cases first occur in NY and then spread out to the whole country and at recent times, places in the south tend to have more cases**
  
```{r}
covid_four_days <- covid19 %>% 
  group_by(state)%>%
  filter(date=="2020-09-16"|date=="2020-07-16"|date=="2020-05-16"|date=="2020-03-16")%>%
  mutate(state_name = str_to_lower(state))
covid_four_days

census_pop_est_2018 <- read_csv("https://www.dropbox.com/s/6txwv3b4ng7pepe/us_census_2018_state_pop_est.csv?dl=1") %>% 
  separate(state, into = c("dot","state"), extra = "merge") %>% 
  select(-dot) %>% 
  mutate(state = str_to_lower(state))

covid_four_day_2018_pop_est <-
  covid_four_days %>% 
  group_by(date)%>%
  left_join(census_pop_est_2018,
            by = c("state_name" = "state")) %>% 
  mutate(cases_per_10000 = (cases/est_pop_2018)*10000)
covid_four_day_2018_pop_est

covid_four_day_2018_pop_est %>% 
  ggplot() +
  geom_map(map = states_map,
           aes(map_id = state_name,
               fill = cases_per_10000)) +
  expand_limits(x = states_map$long, y = states_map$lat) + 
  facet_wrap(vars(date))+
  scale_fill_gradient(low="orange", high="red")+
  theme_map()
```
  
## Minneapolis police stops

These exercises use the datasets `MplsStops` and `MplsDemo` from the `carData` library. Search for them in Help to find out more information.

  14. Use the `MplsStops` dataset to find out how many stops there were for each neighborhood and the proportion of stops that were for a suspicious vehicle or person. Sort the results from most to least number of stops. Save this as a dataset called `mpls_suspicious` and display the table.
  
```{r}
mpls_sus<-MplsStops%>%
  select(neighborhood,problem,long,lat)%>%
  group_by(neighborhood,problem)%>%
  summarize(count=n())%>%
  ungroup(problem)%>%
  mutate(tot=sum(count))%>%
  filter(problem=="suspicious")%>%
  mutate(sus_prop=count/tot)%>%
  arrange(desc(sus_prop))

mpls<-MplsStops%>%
  select(neighborhood,problem,long,lat)%>%
  group_by(neighborhood,problem)
mpls_dup<-mpls[!duplicated(mpls$neighborhood), ]   

mpls_suspicious <-mpls_sus %>% 
  left_join(mpls_dup,
            by = c("neighborhood" = "neighborhood"))  

mpls_suspicious 
```
  
  
  15. Use a `leaflet` map and the `MplsStops` dataset to display each of the stops on a map as a small point. Color the points differently depending on whether they were for suspicious vehicle/person or a traffic stop (the `problem` variable). HINTS: use `addCircleMarkers`, set `stroke = FAlSE`, use `colorFactor()` to create a palette. 
  
```{r}
pal <- colorFactor(palette = c("blue", "red"),domain = MplsStops$problem)
leaflet(data = MplsStops) %>% 
  addProviderTiles(providers$Stamen.Watercolor) %>% 
  addCircles(lng = ~long, 
             lat = ~lat, 
             color = ~pal(problem),
             stroke = FALSE) %>%
  addLegend(pal = pal, 
            values = ~problem, 
            opacity = 0.5, 
            title = "suspicious vehicle/person or a traffic stop",
            position = "bottomright") 
```
  
  
  16. Save the folder from moodle called Minneapolis_Neighborhoods into your project/repository folder for this assignment. Make sure the folder is called Minneapolis_Neighborhoods. Use the code below to read in the data and make sure to **delete the `eval=FALSE`**. Although it looks like it only links to the .sph file, you need the entire folder of files to create the `mpls_nbhd` data set. These data contain information about the geometries of the Minneapolis neighborhoods. Using the `mpls_nbhd` dataset as the base file, join the `mpls_suspicious` and `MplsDemo` datasets to it by neighborhood (careful, they are named different things in the different files). Call this new dataset `mpls_all`.

```{r}
mpls_nbhd <- st_read("Minneapolis_Neighborhoods/Minneapolis_Neighborhoods.shp", quiet = TRUE)

mpls_all <-mpls_nbhd %>% 
  group_by(BDNAME)%>%
  left_join(mpls_suspicious,
            by = c("BDNAME" = "neighborhood"))%>%
  left_join(MplsDemo,
            by = c("BDNAME" = "neighborhood"))
mpls_all
```

  17. Use `leaflet` to create a map from the `mpls_all` data  that colors the neighborhoods by `prop_suspicious`. Display the neighborhood name as you scroll over it. Describe what you observe in the map.
  
```{r}
pal <- colorNumeric(palette = "Blues",domain = mpls_all$sus_prop)
leaflet(data = mpls_all) %>% 
  addTiles() %>% 
  addCircles(lng = ~long, 
             lat = ~lat, 
             label= ~BDNAME,
             color = ~pal(sus_prop))%>%
  addLegend(pal = pal, 
            values = ~sus_prop, 
            opacity = 0.5, 
            title = "Suspicious proportion",
            position = "bottomright") 
```
  
  18. Use `leaflet` to create a map of your own choosing. Come up with a question you want to try to answer and use the map to help answer that question. Describe what your map shows. 
  
  **My question is: What are the income spread around these areas?**
  **People tend to be richer in the south part then the north**
  
```{r}
pal <- colorNumeric(palette = "Purples",domain = mpls_all$hhIncome)
leaflet(data = mpls_all) %>% 
  addTiles() %>% 
  addCircles(lng = ~long, 
             lat = ~lat, 
             label= ~BDNAME,
             color = ~pal(hhIncome),
             popup = ~paste(BDNAME,": ",
                            round(hhIncome, 2),
                            sep=""))%>%
  addLegend(pal = pal, 
            values = ~hhIncome, 
            opacity = 0.5, 
            title = NULL,
            position = "bottomright") 

```
  
  
## GitHub link

  19. Below, provide a link to your GitHub page with this set of Weekly Exercises. Specifically, if the name of the file is 04_exercises.Rmd, provide a link to the 04_exercises.md file, which is the one that will be most readable on GitHub.


**DID YOU REMEMBER TO UNCOMMENT THE OPTIONS AT THE TOP?**
