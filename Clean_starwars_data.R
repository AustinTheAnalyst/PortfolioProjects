library(tidyverse)
View(starwars)


#Viewing the metadata of this data frame
help(starwars)

#Changing variable type of gender
glimpse(starwars)
class(starwars$gender)
unique(starwars$gender)

starwars$gender<-as.factor(starwars$gender)
class(starwars$gender)


#Selecting people with brown,blond, or black hair that is shorter than 175
names(starwars)

starwars %>% 
  select(name,height,ends_with("color")) %>%
  filter(hair_color %in% c("brown","blond","black")&
           height<175)


#Removing NA values from height in order to get the average
mean(starwars$height, na.rm=TRUE)


#View all NA observations 
starwars %>% 
  select(name,gender,hair_color,height) %>% 
  filter(!complete.cases(.))


#Removing all NA values in height
starwars %>% 
  select(name,gender,hair_color,height) %>% 
  filter(!complete.cases(.)) %>% 
  drop_na(height)


#Replace NA in hair_color with 'none'
starwars %>% 
  select(name,gender,hair_color,height) %>% 
  filter(!complete.cases(.)) %>% 
  mutate(hair_color=replace_na(hair_color,"none"))


#Recoding gender to male or female
starwars %>% 
  select(name,gender)

starwars %>% 
  select(name, gender) %>% 
  mutate(gender=recode(gender,
                             "masculine"="male",
                             "feminine"="female"))

