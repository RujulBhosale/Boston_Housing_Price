library(MASS) #box cox
library(caret)
library(car) #for vif #db test
library(corrplot)
library(olsrr)
library(moments)
#View(`housing.(1)`)

#EDA
data=data.frame(`housing.(1)`)
summary(data)


#
qqnorm(data$medv)
attach(data)  
boxplot(medv)

skewness(medv)

pairs(medv~crim,data=data)


#Box-Cox Transformation
y=medv
BoxCoxTrans(y)   #lambda=0.2 approx as 0
y_=log(y)
hist(y_,ylab = "Frequency", xlab="medv", breaks=20,main="Histogram of medv values")
qqnorm(y_)
skewness(y_)


b1=data.frame(cbind(y_,data[,-14]))
chas_=as.factor(chas)
model=lm(y_~crim+zn+indus+chas_+nox+rm+age+dis+rad+tax+ptratio+b+lstat,data=b1)
summary(model)

bd_model = ols_step_backward_p(model)
ols_step_backward_p(model,0.05,details = TRUE)
#plot(bd_model)  #age and indus eliminated
model1=lm(y_~crim+zn+chas_+nox+rm+dis+rad+tax+ptratio+b+lstat,data=b1)
summary(model1)

#VIF Calculation
vif(model1)   #high vif values for rad and tax
cor(b1)  
#drop tax

model2=lm(y_~crim+zn+chas_+nox+rm+dis+rad+ptratio+b+lstat,data=b1)
#summary(model2)
vif(model2)


plot(model2)
summary(model2)



# To test for autocorrelation/independency among residuals
durbinWatsonTest(model2)


#homoscedasticity
install.packages("lmtest")
library(lmtest)
bptest(model2)


summary(model2)
confint(model2)
