# Curve fitting script

# Created by Sam Hince 
# 04/14/2021

# This script is a support script intended to be used for backing out equations 
# for MAE 159
################################################################################

library(ggplot2)
library(equatiomatic)
setwd("/home/sam/Documents/159 plots")

################################################################################

### Figure 2 ###

# import data
F2 <- read.csv(file = './Fig2converntional.csv', header = F)

# find model for y given x
#modelF2 <- lm(V1 ~ poly(V2,3), data=F2)
modelF2 <- lm(V1 ~ V2 + I(V2^2) + I(V2^3), data=F2)

# show model
summary(modelF2)

eqnF2 <- paste("y = ", modelF2$coefficients[4], "* x^3 + ",
                       modelF2$coefficients[3], "* x^2 + ",
                       modelF2$coefficients[2], "* x + ",
                       modelF2$coefficients[1])

print(eqnF2)
# equatiomatic::extract_eq(modelF2, use_coefs = TRUE)

# plot comparison

# sanity check
approx(x = F2$V2, y = F2$V1, xout = 0.5, method="linear")$y
predict(modelF2, data.frame(V2 = 0.5))

### Figure 2 ###

