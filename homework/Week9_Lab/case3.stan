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
  int<lower=1> N;
  vector[N] x;
  vector[N] offset;
  int<lower=0> deaths[N];
}

// The parameters accepted by the model. Our model
// accepts two parameters 'mu' and 'sigma'.
parameters {
  vector[N] alpha;
  real mu;
  real beta;
  real<lower=0> sigma_mu;
}

// The model to be estimated. We model the output
// 'y' to be normally distributed with mean 'mu'
// and standard deviation 'sigma'.
model {
  vector[N] log_lambda;
  
  for (i in 1:N){
    log_lambda[i] = alpha[i] + beta*x[i] + offset[i];
  }
  
  alpha ~ normal(mu, sigma_mu);
  
  mu ~ normal(0, 1);
  beta ~ normal(0, 1);
  sigma_mu ~ normal(0, 1);
  
  deaths ~ poisson_log(log_lambda);
  
}
generated quantities {
  vector[N] theta;  // chance of success

  for (i in 1:N)
    theta[i] = alpha[i] + beta*x[i];
}

