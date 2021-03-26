
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
  vector[T] mu; //Second order mu
}

model {

  y ~ normal(mu[year_i], se);
  
  mu[1] ~ normal(y[1], sigma);
  mu[2] ~ normal(2*y[2] - y[1], sigma);
  mu[3:T] ~ normal(2*mu[2:(T - 1)] - mu[1:(T-2)], sigma);
  
  sigma ~ normal(0, 1);
}

generated quantities{
  //project forward P years
  vector[P] mu_ps; //Second order random walk
  
  mu_ps[1] = normal_rng(2*mu[T] - mu[T-1], sigma);
  mu_ps[2] = normal_rng(2*mu_ps[1] - mu[T], sigma);
  for (j in 3:P){
    mu_ps[j] = normal_rng(2*mu_ps[j-1] - mu_ps[j-2], sigma);
  }
}

