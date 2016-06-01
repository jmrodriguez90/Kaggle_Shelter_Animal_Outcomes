setwd("\\Datos")

#Leyendo los datos
train <- read.csv("train.csv")
test <- read.csv("test.csv")


# Data exploration & preparation
summary(train)
summary(test)

train$Name <- NULL  # Remove name for now
test$Name <- NULL
train$AnimalID <- NULL
test_ID <- test$ID
test$ID <- NULL

# Add some date/time-related variables
library(lubridate)

train$DateTime <- as.POSIXct(train$DateTime)
test$DateTime <- as.POSIXct(test$DateTime)

train$year <- year(train$DateTime)
train$month <- month(train$DateTime)
train$wday <- wday(train$DateTime)
train$hour <- hour(train$DateTime)

test$year <- year(test$DateTime)
test$month <- month(test$DateTime)
test$wday <- wday(test$DateTime)
test$hour <- hour(test$DateTime)

train$DateTime <- as.numeric(train$DateTime)
test$DateTime <- as.numeric(test$DateTime)

# Write a function to convert age outcome to numeric age in days
convert <- function(age_outcome){
  split <- strsplit(as.character(age_outcome), split=" ")
  period <- split[[1]][2]
  if (grepl("year", period)){
    per_mod <- 365
  } else if (grepl("years", period)){ 
    per_mod <- 365
  } else if (grepl("month", period)){ 
    per_mod <- 30
  } else if (grepl("months", period)){ 
    per_mod <- 30
  } else if (grepl("week", period)){
    per_mod <- 7
  } else if (grepl("weeks", period)){
    per_mod <- 7
  } else if (grepl("", period)){
    per_mod <- 0
  } else
    per_mod <- 1
  age <- as.numeric(split[[1]][1]) * per_mod
  return(age)
}

train$AgeuponOutcome <- sapply(train$AgeuponOutcome, FUN=convert)
test$AgeuponOutcome <- sapply(test$AgeuponOutcome, FUN=convert)
train[is.na(train)] <- 0  # Fill NA with 0
test[is.na(test)] <- 0

# Remove row with missing sex label and drop the level
train <- train[-which(train$SexuponOutcome == ""),]
train$SexuponOutcome <- droplevels(train$SexuponOutcome)

# Explore the data
# Outcome by animal type
t1 <- table(train$AnimalType, train$OutcomeType)
t1

prop.table(t1, margin=1)
# Notable differences: 
# 1.3% of cats die, while 0.3% of dogs die
# 24.5% of dogs are returned to owner, 4.5% of cats are returned
# 50% of cats are transferred vs. 25% for dogs

# Animal type vs. subtype
t2 <- table(train$AnimalType, train$OutcomeSubtype)
t2
# Almost all animals flagged as "Aggressive" or "Behavior" are dogs
# 1599 cats are "SCRP" (Stray Cat Return Program) animals

# Subtype is not in test set so remove it
train$OutcomeSubtype <- NULL

# Outcome by sex type
t3 <- table(train$OutcomeType, train$SexuponOutcome)
t3

prop.table(t3, margin=2)

# Initial model
# Remove breed and color for now (many factor levels)
train$Breed <- NULL
test$Breed <- NULL
train$Color <- NULL
test$Color <- NULL

targets <- train$OutcomeType
train$OutcomeType <- NULL


library(xgboost)

#Submission code
set.seed(1234567)
train_matrix <- matrix(as.numeric(data.matrix(train)),ncol=8)
test_matrix <- matrix(as.numeric(data.matrix(test)),ncol=8)

targets_train <- as.numeric(targets)-1

# Run xgb on full train set
xgb_model_test <- xgboost(data=train_matrix, 
                    label=targets_train, 
                    nrounds=300, 
                    verbose=1, 
                    eta=0.05, 
                    max_depth=8, 
                    subsample=0.85, 
                    colsample_bytree=0.85,
                    objective="multi:softprob", 
                    eval_metric="mlogloss",
                    num_class=5)


test_preds <- predict(xgb_model_test, test_matrix)
test_preds_frame <- data.frame(matrix(test_preds, ncol = 5, byrow=TRUE))
colnames(test_preds_frame) <- levels(targets)

submission <- cbind(data.frame(ID=test_ID), test_preds_frame)

write.csv(submission , "13OmitiendoEdadvacía2.csv", row.names=FALSE)
