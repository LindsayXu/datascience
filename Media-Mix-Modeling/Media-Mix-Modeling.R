
# Example which shows possible ways to model tv adstock as part of Media Mix Modeling



adstock_calc_1<-function(media_var,dec,dim){
  length<-length(media_var)
  adstock<-rep(0,length)
  for(i in 2:length){
    adstock[i]<-(1-exp(-media_var[i]/dim)+dec*adstock[i-1])
  }
  adstock
}

adstock_calc_2<-function(media_var,dec,dim){
  length<-length(media_var)
  adstock<-rep(0,length)
  for(i in 2:length){
    adstock[i]<-1-exp(-(media_var[i]+dec*media_var[i-1])/dim)
  }
  adstock
}

#Function for creating test sets

create_test_sets<-function(base_p, trend_p, season_p, ad_p, dim, dec, adstock_form, radio_p, error_std){
  
  #National level model
  
  #Five years of weekly data
  week<-1:(5*52)
  
  #Base sales of base_p units
  base<-rep(base_p,5*52)
  
  #Trend of trend_p extra units per week
  trend<-trend_p*week
  
  #Winter is season_p*10 units below, summer is season_p*10 units above
  temp<-10*sin(week*3.14/26)
  seasonality<-season_p*temp
  
  #7 TV campaigns. Carry over is dec, theta is dim, beta is ad_p,
  tv_grps<-rep(0,5*52)
  tv_grps[20:25]<-c(390,250,100,80,120,60)
  tv_grps[60:65]<-c(250,220,100,100,120,120)
  tv_grps[100:103]<-c(100,80,60,100)
  tv_grps[150:155]<-c(500,200,200,100,120,120)
  tv_grps[200:205]<-c(250,120,200,100,120,120)
  tv_grps[220:223]<-c(100,100,80,60)
  tv_grps[240:245]<-c(350,290,100,100,120,120)
  
  if (adstock_form==2){adstock<-adstock_calc_2(tv_grps, dec, dim)}
  else {adstock<-adstock_calc_1(tv_grps, dec, dim)}
  TV<-ad_p*adstock
  
  radio_spend<-rep(0,5*52)
  radio_spend[40:44]<-c(100, 100, 80, 80)
  radio_spend[92:95]<-c(100, 100, 80, 80)
  radio_spend[144:147]<-c(100, 100, 80)
  radio_spend[196:200]<-c(100, 100, 80, 80)
  radio_spend[248:253]<-c(100, 100, 80, 80, 80)
  
  radio<-radio_p*radio_spend
  
  
  
  #Error has a std of error_var
  error<-rnorm(5*52, mean=0, sd=error_std)
  
  #Full series
  sales<-base+trend+seasonality+TV+radio+error
  
  #Plot
  #plot(sales, type='l', ylim=c(0,1200))
  
  output<-data.frame(sales, temp, tv_grps, radio_spend, week, adstock)
  
  output
  
}

coefs <- NA

for (i in 1:10000) {
  
  test<-create_test_sets(base_p=1000,
                         trend_p=0.8,
                         season_p=4,
                         ad_p=30,
                         dim=100,
                         dec=0.3,
                         adstock_form=1,
                         radio_p=.1,
                         error_std=5)
  lm_std <- lm(sales ~ week+temp+adstock+radio_spend, data=test)
  coefs <- rbind(coefs, coef(lm_std))
  
}				

col_means<-colMeans(coefs[-1,])
for_div<-matrix(rep(col_means,10000), nrow=10000, byrow=TRUE) 
mean_div<-coefs[-1,]/for_div

library(reshape2)
m_coefs<-melt(mean_div)

library(ggplot2)
#Plot the simulated sales
ggplot(data=m_coefs, aes(x=value))+geom_density()+facet_wrap(~Var2, scales="free_y")+ scale_x_continuous('Scaled as % of Mean') 
