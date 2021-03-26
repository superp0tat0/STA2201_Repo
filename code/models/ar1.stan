data {
  int<lower=0> N; // number of observations
  int<lower=0> P; // number of projection years
  vector[N] y; // observations
}
parameters {
  real<lower = -1, upper = 1> rho;
  real<lower=0> sigma;
}
model {
   
   //likelihood
   y[1] ~ normal(0, sigma/sqrt((1-rho^2)));
   y[2:N] ~ normal(rho * y[1:(N - 1)], sigma);
   
   //priors
   rho ~ uniform(-1, 1);
   sigma ~ normal(0,1);
  
}

generated quantities {
  
  //project forward P years
  vector[P] y_p;
  
  y_p[1] = normal_rng(rho*y[N], sigma);
  for( i in 2:P){
    y_p[i] = normal_rng(rho*y_p[i-1], sigma);
  }
  
}

