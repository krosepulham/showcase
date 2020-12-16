# showcase
This repository was made as a place to put some code I was proud of to show to someone who is kind enough to be writing me a letter of recommendation. In this readme, I'll describe each of files. 

## monte_carlo_meta_cv.R 

This piece of code was written as part of a project I did for my class in generalized regression methods in the fall term of 2020. What I wanted to do was demonstrate how Monte-carlo cross validation can be used to estimate the distribution of the accuracy rate ($\frac{number correct predictions}{number of total predictions}$) of a logistic regression model. To do this, I wound up doing the Monte-Carlo cross validation within a holdout cross validation, by setting 100 observations aside to be "new" data that the model would be making predictions on, then performing the Monte-Carlo cross validation on the remaining 599 observations. The purpose of doing it this way was to produce a sort of proof of concept of this type of cross validation to show in my presentation of the project. I used the "biopsy" data set in the MASS package. There were 16 missing values from one variable, so before any cross validation was done I used k-nearest-neighbor hotdeck imputation to impute the missing values. 

## poisson.Rmd

I am including this rmarkdown file to provide context for the poisson_gifs.Rmd file. This is from a project I worked on in December of 2019 about inhomogenous poisson point processes. 

## poisson_gifs.Rmd

I wrote this code to play around with the gifski package and produce some .gif images. I was motivated to do this by wanting to show how the intensity function of an inhomogenous poisson process could be seen in repeated instances of these processes. The first gif is of a point process in 2 spatial dimensions and 1 temporal dimension. The second image is of several iterations of a 1 dimensional process, with the intensity function plotted above the points. 

## baseball_app.R

This is a Shiny app I wrote for a data visualization class I took in the spring of 2020. Baseball has a wide variety of statistics for measuring the performance of the players, but until you're familiar with the game it's difficult to get a sense of what sort of values for these statistics are considered to be "good". So I wrote an application that draws histograms for a given statistic for a given year, where the user has control over the number of histogram bins via a slider. I also made the at-bats a variable that the user has control over, since the data set includes a large number of players who had a small number of at-bats. No one bats 1000, unless they only go to bat once, in which case they only need to hit the ball once to have a batting average of 1.000, which is why I included this widget in the app. The app can be viewed at https://katherine-rose-pulham.shinyapps.io/baseball_app/