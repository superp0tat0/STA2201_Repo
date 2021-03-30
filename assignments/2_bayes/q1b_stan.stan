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
  int<lower = 0, upper = 1> y[N];
  vector[N] dist;
  vector[N] arsenic;
  vector[N] covariate;
}

// The parameters accepted by the model. Our model
// accepts two parameters 'mu' and 'sigma'.
parameters {
  real beta0;
  real beta1;
  real beta2;
  real beta3;
}

// The model to be estimated. We model the output
// 'y' to be normally distributed with mean 'mu'
// and standard deviation 'sigma'.
model {
  beta0 ~ normal(0, 1);
  beta1 ~ normal(0, 1);
  beta2 ~ normal(0, 1);
  beta3 ~ normal(0, 1);
  y ~ bernoulli_logit(beta0 + beta1 * dist + beta2 * arsenic + beta3 * covariate);
}
generated quantities {
  vector[N] log_lik;
  vector[N] log_weight_rep;
  vector[N] logit_p;
  
  for (n in 1:N) {
    log_lik[n] = bernoulli_logit_lpmf(y[n] | beta0 + beta1 * dist[n] + beta2 * arsenic[n] + beta3 * covariate[n]);
    log_weight_rep[n] = bernoulli_logit_rng(beta0 + beta1 * dist[n] + beta2 * arsenic[n] + beta3 * covariate[n]);
  }
  
  for (i in 1:N)
    logit_p[i] = beta0 + beta1 * dist[i] + beta2 * arsenic[i] + beta3 * covariate[i];
}

