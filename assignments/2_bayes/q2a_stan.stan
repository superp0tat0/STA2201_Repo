//
// This Stan program defines a simple model, with a
// vector of values 'y' modeled as normally distributed
// with mean 'mu' and standard deviation 'sigma'.
//
// Learn more about model development with Stan at:
//
//    http://mc-stan.org/users/interfaces/rstan.html
//    https://github.com/stan-dev/rstan/wiki/RStan-Getting-Started
//

// The input data is a vector 'y' of length 'N'.
data {
  int<lower=0> N;
  int<lower=0> C;
  int<lower=0> R;
  int<lower=0, upper=C> country[N];
  int<lower=0, upper=R> region[N];
  vector[N] x1;
  vector[N] x2;
  vector[N] x3;
  vector[N] y;
}

// The parameters accepted by the model. Our model
// accepts two parameters 'mu' and 'sigma'.
parameters {
  real beta_0;
  real beta_1;
  real beta_2;
  real beta_3;
  real<lower=0> sigma_y;
  real<lower=0> sigma_country;
  real<lower=0> sigma_region;
  vector[C] eta_country;
  vector[R] eta_region;
}

// The model to be estimated. We model the output
// 'y' to be normally distributed with mean 'mu'
// and standard deviation 'sigma'.
model {
  vector[N] y_hat;
  
  for (i in 1:N){
    y_hat[i] =  beta_0 + eta_country[country[i]]
                       + eta_region[region[i]]
                       + beta_1 * x1[i]
                       + beta_2 * x2[i]
                       + beta_3 * x3[i];
  }
  
  eta_country ~ normal(0, sigma_country);
  eta_region ~ normal(0, sigma_region);
  beta_0 ~ normal(0,1);
  beta_1 ~ normal(0,1);
  beta_2 ~ normal(0,1);
  beta_3 ~ normal(0,1);
  sigma_country ~ normal(0,1);
  sigma_region ~ normal(0,1);
  sigma_y ~ normal(0,1);
  
  y ~ normal(y_hat, sigma_y);
}

