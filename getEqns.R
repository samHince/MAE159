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

### 
F2_2 <- read.csv(file = './Fig2super.csv', header = F)
modelF2_2 <- lm(V1 ~ V2 + I(V2^2) + I(V2^3), data=F2_2)
eqnF2_2 <- paste("y = ", modelF2_2$coefficients[4], "* x^3 + ",
                 modelF2_2$coefficients[3], "* x^2 + ",
                 modelF2_2$coefficients[2], "* x + ",
                 modelF2_2$coefficients[1])
print(eqnF2_2)

approx(x = F2_2$V2, y = F2_2$V1, xout = 0.5, method="linear")$y
predict(modelF2_2, data.frame(V2 = 0.5))

################################################################################
### Figure 1a ###

F1 <- read.csv(file = './Fig1a35.csv', header = F)
modelF1 <- lm(V2 ~ V1, data = F1)
eqnF1 <- paste("y = ", modelF1$coefficients[2], "* x + ",
               modelF1$coefficients[1])
print(eqnF1)
predict(modelF1, data.frame(V1 = 0.8))

################################################################################
### Figure 3 ###
F3TO <- read.csv(file = './Fig3TO.csv', header = F)
modelF3TO <- lm(V2 ~ V1 + I(V1^2) + I(V1^3), data=F3TO)
eqnF3TO <- paste("y = ", modelF3TO$coefficients[4], "* x^3 + ",
                 modelF3TO$coefficients[3], "* x^2 + ",
                 modelF3TO$coefficients[2], "* x + ",
                 modelF3TO$coefficients[1])
print(eqnF3TO)

approx(x = F3TO$V1, y = F3TO$V2, xout = 0.06, method="linear")$y
predict(modelF3TO, data.frame(V1 = 0.06))

###
F3LDG <- read.csv(file = './Fig3LDG.csv', header = F)
modelF3LDG <- lm(V2 ~ V1 + I(V1^2) + I(V1^3), data=F3LDG)
eqnF3LDG <- paste("y = ", modelF3LDG$coefficients[4], "* x^3 + ",
                  modelF3LDG$coefficients[3], "* x^2 + ",
                  modelF3LDG$coefficients[2], "* x + ",
                  modelF3LDG$coefficients[1])
print(eqnF3LDG)

approx(x = F3LDG$V1, y = F3LDG$V2, xout = 0.06, method="linear")$y
predict(modelF3LDG, data.frame(V1 = 0.06))

################################################################################
### Figure 4 ###
JT8D <- read.csv(file = './Fig4.csv', header = F)
modelJT8D <- lm(V2 ~ V1 + I(V1^2) + I(V1^3), data=JT8D)
eqnJT8D <- paste("y = ", modelJT8D$coefficients[4], "* x^3 + ",
                 modelJT8D$coefficients[3], "* x^2 + ",
                 modelJT8D$coefficients[2], "* x + ",
                 modelJT8D$coefficients[1])
print(eqnJT8D)

approx(x = JT8D$V1, y = JT8D$V2, xout = 5145, method="linear")$y
predict(modelJT8D, data.frame(V1 = 5145))

################################################################################
### Figure 5 ###
Fig5eng2 <- read.csv(file = './Fig5eng2.csv', header = F)
modelFig5eng2 <- lm(V1 ~ V2 + I(V2^2) + I(V2^3), data=Fig5eng2)
eqnFig5eng2 <- paste("y = ", modelFig5eng2$coefficients[4], "* x^3 + ",
                 modelFig5eng2$coefficients[3], "* x^2 + ",
                 modelFig5eng2$coefficients[2], "* x + ",
                 modelFig5eng2$coefficients[1])
print(eqnFig5eng2)

approx(x = Fig5eng2$V2, y = Fig5eng2$V1, xout = 10000, method="linear")$y
predict(modelFig5eng2, data.frame(V2 = 10000))

###
Fig5eng4 <- read.csv(file = './Fig5eng4.csv', header = F)
modelFig5eng4 <- lm(V1 ~ V2 + I(V2^2) + I(V2^3), data=Fig5eng4)
eqnFig5eng4 <- paste("y = ", modelFig5eng4$coefficients[4], "* x^3 + ",
                  modelFig5eng4$coefficients[3], "* x^2 + ",
                  modelFig5eng4$coefficients[2], "* x + ",
                  modelFig5eng4$coefficients[1])
print(eqnFig5eng4)

approx(x = Fig5eng4$V2, y = Fig5eng4$V1, xout = 10000, method="linear")$y
predict(modelFig5eng4, data.frame(V2 = 10000))

################################################################################
### Figure JT9D_SL ###
JT9D_SL <- read.csv(file = './JT9D_SL.csv', header = F)
modelJT9D_SL <- lm(V2 ~ V1 + I(V1^2) + I(V1^3), data=JT9D_SL)
eqnJT9D_SL <- paste("y = ", modelJT9D_SL$coefficients[4], "* x^3 + ",
                    modelJT9D_SL$coefficients[3], "* x^2 + ",
                    modelJT9D_SL$coefficients[2], "* x + ",
                    modelJT9D_SL$coefficients[1])
print(eqnJT9D_SL)

approx(x = JT9D_SL$V1, y = JT9D_SL$V2, xout = 0.2, method="linear")$y
predict(modelJT9D_SL, data.frame(V1 = 0.2))
