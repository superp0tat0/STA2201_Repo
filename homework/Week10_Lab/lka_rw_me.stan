
data {
  int<lower=0> N; // number of observations
  int<lower=0> T; //number of years
  int<lower=0> P; //number of projection years
  vector[N] y; // log ratio
  int<lower=0> year_i[N]; //year index of observations
  vector[N] se; // standard errors around observations
}

parameters {
  real<lower=0> sigma;
  vector[T] mu; //First order mu
}

model {

  y ~ normal(mu[year_i], se);
  mu[1] ~ normal(y[1], sigma);
  mu[2:T] ~ normal(mu[1:(T - 1)], sigma);
  
  sigma ~ normal(0, 1);
}

generated quantities{
  //project forward P years
  vector[P] mu_p; //first order fit
  
  mu_p[1] = normal_rng(mu[T], sigma);
  for( i in 2:P){
    mu_p[i] = normal_rng(mu_p[i-1], sigma);
  }
}

