#Gompertz mortality

gompertz_haz <- function(a, b, x){
  y <- a * exp(b*x)
  return(y)
}

y <- gompertz_haz(a = 0.2, b = 0.1, x = 0:50)
y
plot(y)

gompertz_cdf <- function(a, b, x){
  cdf <- 1 - exp(-a*exp(b*x))
  return(cdf)
}

cdf_y <- gompertz_cdf(a = 0.2, b = 0.1, x = 0:50)
plot(cdf_y)
diff(cdf_0_10)
plot(diff(cdf_0_10))
