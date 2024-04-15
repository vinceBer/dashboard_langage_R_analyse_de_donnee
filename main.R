# Load necessary libraries
library(shiny)
library(shinydashboard)
library(ggplot2)
library(dplyr)
library(lubridate)
library(leaflet)
library(leaflet.extras)
library(plotly)
library(DT)
library(tidyverse)


# Charger les variables depuis un autre fichier (variables.R)
source("variables.R")

# Créer l'interface utilisateur du tableau de bord
ui <- dashboardPage(
  dashboardHeader(
    title = div("Powerlifting Dashboard"),
    titleWidth = 200
  ),
  dashboardSidebar(
    width = 150,
    sidebarMenu(
      # Définir les onglets du menu latéral
      menuItem("Accueil", tabName = "accueil", icon = icon("home")),
      menuItem("Athlètes", tabName = "athlete", icon = icon("tv")),
      menuItem("Records", tabName = "record", icon = icon("trophy")),
      menuItem("A propos", tabName = "more", icon = icon("user"))
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "accueil",
              fluidRow(
                # Afficher le nombre de participants, le plus gros total et le meilleur athlète en termes de goodlift points
                box(
                  title = "Nombre de Participant ",
                  nombre_participants,
                  width = 3,
                  length = 5,
                  background = "red",
                  style = "font-size: 14px;" 
                ),
                box(
                  title = "Le plus gros total",
                  paste(max_name, ": ", max_total_kg," kg"),
                  width = 3,
                  length = 5,
                  background = "blue",
                  style = "font-size: 14px;" 
                ),
                box(
                  title = "Meilleur(e) Athlète goodlift points",
                  paste(max_goodlift_name,
                        " Poids: ", max_goodlift_weight, " kg",
                        " Total: ", max_goodlift_total_kg, " kg"),
                  width = 3,
                  length = 5,
                  background = "green",
                  style = "font-size: 14px;" 
                ),
              ),
              # Afficher le graphique dynamique, le tableau des participants et une carte
              box(
                title = "Total en kg pour les athlètes français à l'international",
                plotOutput("dynamic_plot"),
              ),
              box(
                title = "Vue d'ensemble des participants à Sheffiled Championship",
                dataTableOutput("participants_table")
              ),
              leafletOutput("map"),
              verbatimTextOutput("Selected_data")
      ),
      tabItem(tabName = "athlete",
              # Afficher l'histogramme de la répartition des athlètes selon l'âge, 
              # la distribution selon le genre, le sélecteur de genre et la distribution selon les catégories de poids
              box(
                title = "Répartition des athlètes selon l'âge",
                plotOutput("histogram"),
              ),
              box(
                title = "Distribution des athlètes selon le genre",
                plotOutput("gender_distribution"),
                width = 4
              ),
              box(
                selectInput("selected_gender", "Choisissez le genre", choices = c("M", "F")),
                width = 4
              ),
              box(
                title = "Distribution des athlètes selon les catégories de poids",
                plotOutput("weight_category_distribution")
              )
      ),
      tabItem(tabName = "record",
              # Afficher le sélecteur de genre, le sélecteur de mouvement, 
              # le slider d'année et le graphique des meilleures performances
              box(
                title = "Meilleur Performance par catégorie de poids",
                selectInput("gender", "Choisisez le genre", choices = c("M", "F")),
                selectInput("lift", "Choisissez le mouvement", choices = c("DeadliftKg", "BenchKg", "SquatKg", "TotalKg")),
                sliderInput("year", "Selectionner l'année", min = 2000, max = 2023, value = 2023),
                plotOutput("best_performance_plot")
              )
      ),
      tabItem(tabName = "more",
              tabsetPanel(
                # Afficher les informations sur le powerlifting et sur le jeu de données,
                # ainsi que la distribution des athlètes par pays et le timeline des compétitions
                tabPanel("A propos du Powerlifting", textOutput("powerlifting_overview")),
                tabPanel("Information sur le jeu de donnée", textOutput("dataset_info"))
              ),
              box(
                title = "Distribution des athlètes en fonction des pays",
                plotOutput("meet_country_distribution")
              ),
              box(
                title = "Nombre de compétitions selon les années",
                plotOutput("competition_timeline")
              )
      )
    )
  )
)


#Server logic
server <- function(input, output) {
  
  ####Create a histogram for "Category 2"
  output$histogram <- renderPlot({
    filtered_data <- powerlifting_cleaned 
    ggplot(filtered_data, aes(x = Age)) +
      geom_histogram(binwidth = 1, fill = "blue", color = "black") +
      labs(x = "Age", y = "Frequence")
  })
  
  ####Create the pie chart for category 2 
  output$gender_distribution <- renderPlot({
    #Calculate the distribution of athletes by gender
    gender_distribution <- powerlifting_cleaned %>%
      group_by(Sex) %>%
      summarise(count = n())
    
    #Create a pie chart
    ggplot(gender_distribution, aes(x = "", y = count, fill = Sex)) +
      geom_bar(stat = "identity") +
      coord_polar("y") +
      labs(title = "Distribution des athlètes par genre") +
      scale_fill_manual(values = c("M" = "blue", "F" = "pink")) +
      guides(fill=guide_legend(title=NULL)) +
      theme_void()
  })
  
  
  ####Athlete per category
  output$weight_category_distribution <- renderPlot({
    selected_gender <- input$selected_gender
    
    #Filter data on gender
    filtered_data <- powerlifting_cleaned %>%
      filter(Sex == selected_gender)
    
    #distribution by weight category 
    weight_category_distribution <- filtered_data %>%
      group_by(WeightCategory) %>%
      summarise(count = n())
    
    #Create a bar plot
    ggplot(weight_category_distribution, aes(x = WeightCategory, y = count)) +
      geom_bar(stat = "identity", fill = "blue", color = "black") +
      labs(
        title = paste("Distribution des athlètes pour les", selected_gender),
        x = "Categorie de poids",
        y = "Nombre d'athlètes"
      ) +
      theme_minimal()
  })
  
  # Créer la carte Leaflet avec des marqueurs et une légende
  output$map <- renderLeaflet({
    # Créer la carte Leaflet
    leaflet() %>%
      setView(lng = center_coords[2], lat = center_coords[1], zoom = 2) %>%
      addTiles() %>%
      addAwesomeMarkers(data = grouped_data, ~Longitude, ~Latitude,
                        icon = icons,
                        popup = ~paste("Pays: ", CountryName, "<br>Nombre de participants: ", TotalParticipants),
                        clusterOptions = markerClusterOptions(),
                        group = ~MarkerColor  # Regrouper les marqueurs par couleur
      ) %>%
      addLegend(position = "bottomleft",
                colors = colors,
                labels = c("Participants <= 1000", "1000 < Participants <= 5000",
                           "5000 < Participants <= 10000", "10000 < Participants <= 30000",
                           "Participants > 30000"),
                title = "Légende")
  })
  
  
  ####plot for category 1 french athletes
  output$dynamic_plot <- renderPlot({
    filtered_data2 <- powerlifting_cleaned %>%
      filter(Event == "SBD", Place == "1", Age <= 23, Sex == "M", ParentFederation == "IPF", Country == "France")
    
    #transform date in date variable
    filtered_data2$Date <- as.Date(filtered_data2$Date)
    filtered_data2$Year <- as.integer(format(filtered_data2$Date, "%Y"))
    
    ggplot(filtered_data2, aes(x = Year, y = TotalKg, color = WeightCategory)) +
      geom_point() +
      labs(title = "Total en Kg par An", x = "Année", y = "Total en Kg") +
      scale_color_manual(
        values = c(
          "-57kg" = "red",
          "-66kg" = "blue",
          "-74kg" = "green",
          "-83kg" = "orange",
          "-93kg" = "purple",
          "-105kg" = "pink",
          "-120kg" = "brown",
          "+120kg" = "gray"
        )
      ) +
      scale_x_continuous(breaks = unique(filtered_data2$Year))
  })
  
  
  ####table in category 1 
  event_participants <- powerlifting_cleaned %>%
    filter(MeetName == "Sheffield Powerlifting Championships") %>%
    select(Name, Sex, WeightCategory, Age, BodyweightKg, TotalKg)
  
  # Render the table using DT
  output$participants_table <- renderDataTable({
    datatable(
      event_participants,
      options = list(pageLength = 8)
    )
  })
  
  
  
  ####Category 3 
  output$best_performance_plot <- renderPlot({
    # Filter data based on the selected gender, lift, and year
    filtered_data <- powerlifting_cleaned %>%
      filter(
        Sex == input$gender,
        year(Date) == input$year,
        !is.na(get(paste0("Best3", input$lift))) | input$lift == "TotalKg"
      )
    
    #condition to display only one lift at a time 
    summarized_data <- filtered_data %>%
      group_by(WeightCategory) %>%
      summarise(
        BestPerformance = if (input$lift == "TotalKg") {
          max(TotalKg, na.rm = TRUE)
        } else {
          ifelse(
            any(!is.na(get(paste0("Best3", input$lift))), na.rm = TRUE),
            max(get(paste0("Best3", input$lift)), na.rm = TRUE),
            NA
          )
        }
      )
    
    # Create the plot
    ggplot(summarized_data, aes(x = WeightCategory, y = BestPerformance)) +
      geom_bar(stat = "identity", fill = "blue") +
      labs(
        title = paste("Best", input$lift, "Performance par categorie de poids"),
        x = "Categorie de poids",
        y = paste("Best", input$lift)
      )
  })
  
  
  #### Category 4 plot 1 
  output$meet_country_distribution <- renderPlot({
    #amount of athlete per country
    meet_country_counts <- powerlifting_cleaned %>%
      group_by(MeetCountry) %>%
      summarise(AthleteCount = n()) %>%
      arrange(desc(AthleteCount))
    
    #keep only the 10 first country
    N <- 10  # You can adjust N as needed
    top_meet_countries <- head(meet_country_counts, N)
    top_meet_countries$MeetCountry <- factor(top_meet_countries$MeetCountry)
    
    #the rest goes in "Other"
    other_meet_countries <- meet_country_counts %>%
      filter(!(MeetCountry %in% top_meet_countries$MeetCountry))
    other_meet_countries <- other_meet_countries %>%
      summarise(AthleteCount = sum(AthleteCount))
    other_meet_countries$MeetCountry <- "Autres"
    
    #everything goes back together
    combined_meet_countries <- rbind(top_meet_countries, other_meet_countries)
    
    # Create the bar chart
    ggplot(combined_meet_countries, aes(x = reorder(MeetCountry, -AthleteCount), y = AthleteCount)) +
      geom_bar(stat = "identity", fill = "blue") +
      labs(title = "Distribution des athlètes par pays (MeetCountry)", x = "Pays (MeetCountry)", y = "Nombre d'athlète") +
      theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1))
  })
    
    
  
  
  ####Category 4 plot 2 
  output$competition_timeline <- renderPlot({
    # Extract the year from the Date column
    powerlifting_cleaned$Date <- as.Date(powerlifting_cleaned$Date)
    powerlifting_cleaned$Year <- as.integer(format(powerlifting_cleaned$Date, "%Y"))
    
    # Count the number of competitions per year
    competition_counts <- powerlifting_cleaned %>%
      group_by(Year) %>%
      summarise(CompetitionCount = n())
    
    # Create the timeline chart
    ggplot(competition_counts, aes(x = Year, y = CompetitionCount)) +
      geom_line(color = "blue") +
      labs(title = "Evolution du nombre de compétitions par an", x = "Année", y = "Nombre de compétition") +
      scale_x_continuous(breaks = unique(competition_counts$Year))
  })
   
  output$powerlifting_overview <- renderText({
    "

Powerlifting : Force, Performance et Compétition
Le powerlifting est un sport de force où l'objectif principal est de soulever des poids lourds dans trois mouvements spécifiques : le squat, le développé couché (bench press), et le soulevé de terre (deadlift). Ces trois mouvements sollicitent divers groupes musculaires, offrant un défi complet de force et d'endurance.

Déroulement d'une Compétition de Powerlifting :

Pesée : Avant le début de la compétition, les athlètes sont pesés pour déterminer leur catégorie de poids. Les catégories de poids permettent une compétition équitable entre les athlètes de poids similaire.

Tentatives de Squat : Chaque athlète a trois tentatives pour effectuer un squat. L'objectif est de soulever le poids le plus lourd possible. Les juges vérifient que le squat est effectué selon les règles.

Tentatives de Développé Couché : De la même manière, les athlètes ont trois tentatives pour effectuer un développé couché, visant à soulever le plus de poids possible tout en respectant les règles strictes.

Tentatives de Soulevé de Terre : Le soulevé de terre est le dernier mouvement. Les athlètes tentent de soulever un poids maximal. Comme pour les autres mouvements, les règles doivent être suivies.

Calcul du Total : Le total d'un athlète est la somme des poids soulevés dans les trois mouvements. Le total détermine le classement.

Prix et Reconnaissance : À la fin de la compétition, les athlètes sont classés en fonction de leur total. Des médailles ou des prix sont souvent décernés aux meilleurs compétiteurs dans différentes catégories de poids.

Le powerlifting est un sport qui exige une combinaison de force pure, de technique et de détermination. Il offre aux athlètes la possibilité de repousser leurs limites et de se dépasser. Les compétitions attirent des participants du monde entier, offrant un spectacle captivant pour les amateurs de sports de force."
  })
  
  output$dataset_info <- renderText({
    "

Jeu de Données du Powerlifting : Explorer la Force en Chiffres
Notre jeu de données est une mine d'informations sur le monde passionnant du powerlifting. Il contient des enregistrements de compétitions de powerlifting du monde entier et offre un aperçu détaillé des performances des athlètes, des compétitions et des fédérations. Voici ce que vous pouvez découvrir dans notre jeu de données :

Données Démographiques : Les colonnes telles que Sexe, Âge et Catégorie de Poids fournissent des informations sur les athlètes et leur profil démographique.

Performances : Le powerlifting consiste en trois mouvements principaux : le squat, le développé couché et le soulevé de terre. Les colonnes SquatKg, BenchKg et DeadliftKg indiquent les performances de chaque athlète dans ces mouvements, tandis que la colonne TotalKg représente leur score global.

Compétitions : Vous pouvez explorer les détails des compétitions, y compris les noms des événements, les dates, les lieux et les fédérations qui les ont organisées.

Pays et Fédérations : Notre jeu de données répertorie les pays d'origine des athlètes, ainsi que les fédérations auxquelles ils sont affiliés. Cela vous permet d'explorer la répartition géographique des athlètes et l'impact des fédérations sur le sport.

Résultats : Outre les performances brutes, notre jeu de données contient des informations sur le classement des athlètes dans chaque compétition."
  })
  
   
}
  
#Run the app
shinyApp(ui, server)
