# Load necessary libraries
library(tidyverse)
library(data.table)

# Load the movies data
movies <- fread("ml-10M100K/movies.dat", sep = "::", header = FALSE, col.names = c("MovieID", "Title", "Genres"))

# Load the ratings data
ratings <- fread("ml-10M100K/ratings.dat", sep = "::", header = FALSE, col.names = c("UserID", "MovieID", "Rating", "Timestamp"))

# Convert Timestamp to a date format
ratings$Timestamp <- as.POSIXct(ratings$Timestamp, origin = "1970-01-01")

# Extract year from the movie title
movies$Year <- as.numeric(sub(".*\\((\\d{4})\\).*", "\\1", movies$Title))

set.seed(123)
train_indices <- sample(seq_len(nrow(ratings)), size = 0.8 * nrow(ratings))
train_set <- ratings[train_indices, ]
validation_set <- ratings[-train_indices, ]

# Example: Using a simple average rating model
mu <- mean(train_set$Rating)

# Predict ratings in the validation set
validation_set$PredictedRating <- mu

# Calculate RMSE
rmse <- sqrt(mean((validation_set$Rating - validation_set$PredictedRating)^2))
print(paste("RMSE:", rmse))
