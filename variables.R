library(dplyr)

#fonctions

#reading the dataset
powerlifting_data1 <- read.csv("power.csv")
data_capitale_fichier <- read.csv("capitale.csv")

data_capitale_fonction <- function(data_capitale){
  # mapping de la capitale
  mapping_capitales <- list(
    "Cote d'Ivoire" = 'Ivory Coast'
  )
  # Remplacement des noms de pays dans la colonne 'CountryName' du DataFrame data_capitale
  data_capitale_new <- data_capitale %>%
    mutate(CountryName = recode(CountryName, !!!mapping_capitales))
  
  return(data_capitale_new)
}


data_powerlifting_fonction <- function(powerlifting_fichier){
  #mapping de du fichier powerlifting
  mapping <- list(
    "USSR" = 'Russia',
    "Czechia" = 'Czech Republic',
    "Tahiti" = 'French Polynesia',
    "UAE" = 'United Arab Emirates',
    "England" = 'United Kingdom',
    "USA" = 'United States',
    "UK" = '"United Kingdom',
    "Scotland" = 'United Kingdom',
    "Wales" = 'United Kingdom',
    "N.Ireland" = 'Ireland',
    "West Germany" = 'Germany',
    "Congo" = 'Republic of Congo',
    "North Macedonia" = 'Macedonia'
  )
  
  # Modifier le fichier en remplaçant les noms de pays
  powerlifting_data <- powerlifting_fichier %>%
    mutate(Country = recode(Country, !!!mapping)) %>%
    # Supprimer les lignes avec des valeurs manquantes dans TotalKg
    filter(!is.na(TotalKg)) %>%
    # Filtrer les athlètes non équipés
    filter(Equipment == "Raw") %>%
    # Filtrer les données antérieures à 2000-01-01
    filter(Date > as.Date("2000-01-01")) %>%
    # Créer une colonne avec la catégorie de poids actuelle
    mutate(WeightCategory = case_when(
      Sex == "M" ~ case_when(
        BodyweightKg < 59 ~ "-59kg",
        BodyweightKg < 66 ~ "-66kg",
        BodyweightKg < 74 ~ "-74kg",
        BodyweightKg < 83 ~ "-83kg",
        BodyweightKg < 93 ~ "-93kg",
        BodyweightKg < 105 ~ "-105kg",
        BodyweightKg < 120 ~ "-120kg",
        TRUE ~ "+120kg"
      ),
      Sex == "F" ~ case_when(
        BodyweightKg < 47 ~ "-47kg",
        BodyweightKg < 52 ~ "-52kg",
        BodyweightKg < 57 ~ "-57kg",
        BodyweightKg < 63 ~ "-63kg",
        BodyweightKg < 69 ~ "-69kg",
        BodyweightKg < 76 ~ "-76kg",
        BodyweightKg < 84 ~ "-84kg",
        TRUE ~ "+84kg"
      ),
      TRUE ~ NA_character_  # Définir à NA si les données sur le poids du corps sont manquantes
    )) %>%
    # Supprimer les colonnes inutiles
    select(-BirthYearClass, -Division, -WeightClassKg, -State) %>%
    # Copier TotalKg dans une nouvelle colonne Best3TotalKg
    mutate(Best3TotalKg = TotalKg)
  
  return(powerlifting_data)
}


regrouped_data_final <- function(data_capitale, powerlifting_cleaned){
  # Fusionner les données et filtrer les valeurs non valides
  grouped_data <- merge(data_capitale, powerlifting_cleaned, by.x ='CountryName', by.y='Country') %>%
    filter(CapitalLatitude != 0, CapitalLongitude != 0) %>%
    # Grouper les données par CapitalName et CountryName, puis calculer les statistiques
    group_by(CapitalName, CountryName) %>%
    summarise(
      TotalParticipants = n(),  # Nombre total de participants pour chaque combinaison unique de capitale et de pays
      Latitude = first(CapitalLatitude),  # Prendre la première valeur de latitude pour chaque combinaison unique
      Longitude = first(CapitalLongitude)  # Prendre la première valeur de longitude pour chaque combinaison unique
    )
  
  return(grouped_data)
}


data_capitale <- data_capitale_fonction(data_capitale_fichier)
powerlifting_cleaned <- data_powerlifting_fonction(powerlifting_data1)
grouped_data <- regrouped_data_final(data_capitale, powerlifting_cleaned)




#### Pour les statistiques page 1 


# Pour avoir le nombre total de participants
nombre_participants <- nombre_participants <- n_distinct(powerlifting_cleaned$Name)


#row with the max Totalkg
max_total_row <- powerlifting_cleaned %>%
  filter(TotalKg == max(TotalKg, na.rm = TRUE)) %>%
  select(Name, TotalKg)

#extract the name of the max total
max_name <- max_total_row$Name
max_total_kg <- max_total_row$TotalKg


#athlete with the most goodlift point on sbd
max_goodlift_row <- powerlifting_cleaned %>%
  filter(Event == "SBD") %>%
  group_by(Event) %>%
  filter(Goodlift == max(Goodlift, na.rm = TRUE)) %>%
  select(Name, BodyweightKg, TotalKg)

#extract name and total 
max_goodlift_name <- max_goodlift_row$Name
max_goodlift_weight <- max_goodlift_row$BodyweightKg
max_goodlift_total_kg <- max_goodlift_row$TotalKg





#### Utilisé pour les paramètres de la carte

# Créer les marqueurs en fonction de MarkerColor
icons <- awesomeIcons(
  icon = 'ios-close',
  iconColor = 'black',
  library = 'ion',
  markerColor = ~MarkerColor  # Utiliser la couleur définie dans MarkerColor
)
# Définir les intervalles et les couleurs correspondantes
intervals <- c(0, 1000, 5000, 10000, 30000, Inf)
colors <- c("black", "red", "orange", "green", "pink")

# Ajouter une colonne 'MarkerColor' à grouped_data en fonction de TotalParticipants
grouped_data$MarkerColor <- cut(grouped_data$TotalParticipants, breaks = intervals, labels = colors)

# Coordonnées du centre de la carte
center_coords <- c(50, 10)