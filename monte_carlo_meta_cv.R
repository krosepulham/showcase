library(dplyr)
library(simputation)
library(VIM)
library(ggplot2)

####################
#Monte carlo cross-validation for error rate 

#set seed for RNG reproducibility
set.seed(134896)

#getting the data from the mass package
biopsy <- MASS::biopsy%>%
  mutate(malignant=class=="malignant")%>% #making this a logical vector ==malignant
  select(-ID,-class)
length(biopsy[,1]) #there are 699 observations in this dataset

#variable V6 contains missing values:
sum(is.na(biopsy$V6))
#so we must impute for that vector. To do this, I'm going to use the simputation
#package with a VIM backend to impute:
biopsy$V6 <- impute_knn(biopsy,V6~.-malignant,backend="VIM")$V6
sum(is.na(biopsy$V6))

#let's use a "observations" data set of 599, and a "predictions" data set of 100
samp_index <- sample(1:699,599,replace=FALSE)
observations <- biopsy[samp_index,]
for_pred <- biopsy[-samp_index,]

#now we need to define a function that will take a partition of the 
#observations, fit a logistic regression on the training part of that partition,
#make predictions for the testing part of the partition, and use that to
#estimate the proportion of correct/incorrect predictions. let's use a p of 20
#for the number of observations we wish to leave out each time. Each partition
#will be uniquely defined by a vector of 20 integers which index the numbers
#that will be left out, so that vector of 20 integers will be the argument this
#function takes in. It will output the estimated error rate (not distinguishing
#between false positives and negatives).
monte_rep <- function(x){
  mod <- glm(malignant~.,
             family=binomial(link="logit"),
             data=observations[-x,])
  #predictions will be a predicted log(odds) of the observation. So we should 
  #predict not cancer for p>0.5, which means logit(p)>0
  predictions <- predict(mod,observations[x,])>0
  
  #check to see which predictions were correct, and add up the total. 
  correct <- predictions==observations[x,]$malignant
  return(mean(correct))
}

#now that we've defined our function, we will produce a large number (10,000) of
#partition-defining 100-tuples, organize them into a list, then apply the
#repetition function to each 100-tuple in the list. to speed things up, I'll be
#using the purrr package
nrep <- 10000
sampsize <- 100

#create a list of partition defining n-tuples
dexlist <- as.list(rep(NA,nrep))
for(i in 1:nrep){
  dexlist[[i]] <- sample(1:500,sampsize,replace=FALSE)
}

#calculate the accuracy rate of each partition
correct <- purrr::map_dbl(dexlist,monte_rep) #this takes about a minute on my PC
correct_rate <- mean(correct)

#calculate point estimate, interval estimate, and plot histogram
correct_rate
c(quantile(correct,0.025),quantile(correct,0.975))
qplot(correct*sampsize,geom="bar")+
  labs(x="Number of Correct Predictions out of 100",
       y="Frequency",
       title="Monte Carlo Cross-validation")
#To see how this measures up to the data we set aside for prediction, we first 
#fit the model, then make the predictions, and compare to the estimates above.
mod <- glm(malignant~.,
           family=binomial(link="logit"),
           data=observations)
predictions <- predict(mod,for_pred)>0

#check to see which predictions were correct, and add up the total. 
sum(predictions==for_pred$malignant)
#so we see that the model was accurate at the same rate we would expect it to 
#be based on the cross validation. This seed happened to produce a point
#estimate that was very close to the actual error rate. 