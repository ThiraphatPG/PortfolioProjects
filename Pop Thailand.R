#The data global of population age 65 and above is collected from https://data.worldbank.org and 
#the data of population in Thailand is collected from http://www.nso.go.th/
# library package that will be used to extract and manipulate datalibrary(tidyverse)
library(tidyverse)

library(xlsx)

library(readxl)

#Import data into R
Pop_Thai <- read_excel("Population_by_Province.xlsx")

### Cleaning data for visualization in Tableau
Total_pop_Thai <- Pop_Thai %>% pivot_longer(c("2011":"2020"), names_to = "Year", values_to = "Number_of_Pop")

View(Total_pop_Thai)

Total_pop_Thai <- Total_pop_Thai %>% rename("Age_group" = 'Age group')

write.xlsx(Total_pop_Thai, "Total_pop_Thai.xlsx")

head(Total_pop_Thai)

str(Total_pop_Thai)

# manipulate data by rename column and make data wider
Total_pop_Thai <- Total_pop_Thai %>% group_by(Age_group) %>% mutate(row = row_number()) %>%
        pivot_wider(names_from = Age_group, values_from = Number_of_Pop) %>%
        select(-row)

str(Total_pop_Thai)

new <- Total_pop_Thai

new <- new %>% filter(!is.na(new$Province))

new$Province <- new$Province %>% str_remove_all("Province")

new$Province <- str_trim(new$Province)

new <- new %>% select(-c(30))

new <- new %>% filter(!is.na(Total))

new <- new %>% rename('over_hundred' = '100 and over' )

want_elderly <- new %>% select(c('65-69':'over_hundred'))

rowSums(want_elderly)

View(new)

new <- new %>% mutate(percentage_elderly = (Elderly/Total)*100)

new$Elderly <- rowSums(want_elderly)

write.xlsx(new, 'clean_population_data.xlsx')

###World Elderly population
world_pop <- read_excel("World_Pop.xlsx")

world_pop <- world_pop %>% pivot_longer(c("1996":"2019"),names_to = 'Year', values_to = 'Percent')

world_pop <- world_pop %>% filter(Percent != 'na')

#Change the data type for calculation and visulization in Tableau
world_pop$Percent <- as.double(world_pop$Percent)

world_pop$Year <- as.factor(as.integer(world_pop$Year))

View(world_pop)

write.xlsx(world_pop, "World_percent_elderly_cleaned.xlsx")

###Create Table for The number of elderly for each province in 2020
Province_of_Thailand <- Total_pop_Thai %>% select(Province, Age_group, Year, Number_of_Pop) %>% 
        filter(Age_group == "Total", Year == "2020")

unique(Total_pop_Thai$Age_group)

except_Bangkok <- as.list(Province_of_Thailand$Province[2:nrow(Province_of_Thailand)])

except_Bangkok <- as.list(trimws(Province_of_Thailand$Province, "right", "\\w"))

except_Bangkok <- except_Bangkok[-c(1)]

Province_of_Thailand$Province[2:nrow(Province_of_Thailand)] <- except_Bangkok

Province_of_Thailand$Province<- str_trim(Province_of_Thailand$Province)

write.xlsx(Province_of_Thailand, "Province_of_Thailand.xlsx")

# World Elderly manipulation
world_elderly <- read_excel("elderly.xlsx")

world_elderly <- world_elderly %>% pivot_longer(c("1996":"2019"), names_to = "Year", values_to = "Percent")

write.xlsx(world_elderly, "Cleaned_world_elderly.xlsx")
