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
  int<lower=0> J;
  int<lower=1, upper=J> county[N];
  vector[N] y;
  vector[N] x;
  vector[J] u;
}

// The parameters accepted by the model. Our model
// accepts two parameters 'mu' and 'sigma'.
parameters {
  real gamma0;
  real gamma1;
  real beta;
  real<lower=0> sigma_alpha;
  real<lower=0> sigma;
  vector[J] alpha;
}

// The model to be estimated. We model the output
// 'y' to be normally distributed with mean 'mu'
// and standard deviation 'sigma'.
model {
  vector[N] y_hat;
  vector[J] alpha_hat;
  
  for (i in 1:N){
    y_hat[i] = alpha[county[i]] + x[i] * beta;
  }
  
  for (j in 1:J){
    alpha_hat[j] = gamma0 + gamma1*u[j];
  }
  
  alpha ~ normal(alpha_hat, sigma_alpha);
  beta ~ normal(0,1);
  sigma ~ normal(0,1);
  sigma_alpha ~ normal(0,1);
  
  y ~ normal(y_hat, sigma);
}

