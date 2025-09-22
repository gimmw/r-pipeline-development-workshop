functions {
  real cum_loss(int dev, real ult, real omega, real theta) {
    return ult * (1 - exp(-(dev / theta)^omega));
  }
}

data {
    int<lower=0> N;
    int<lower=1> AY_J;

    array[N] int<lower=1, upper=AY_J> AY;
    array[N] int<lower=0> dev;
    array[N] int<lower=0> premium;
    array[N] real<lower=0> cum;
}

parameters {
  real alpha_ult_mu;
  real<lower=0> alpha_ult_sigma;
  vector[AY_J] alpha_ult_raw;
    
  real alpha_omega_mu;
  real<lower=0> alpha_omega_sigma;
  real alpha_omega_raw;
  
  real alpha_theta_mu;
  real<lower=0> alpha_theta_sigma;
  real alpha_theta_raw;
  
  real alpha_sigma_mu;
  real<lower=0> alpha_sigma_sigma;
  real alpha_sigma_raw;
  
}

transformed parameters {
  vector[AY_J] ult;
  real omega;
  real theta;
  real<lower=0> sigma;
  
  ult = alpha_ult_mu + alpha_ult_sigma * alpha_ult_raw;
  omega = alpha_omega_mu + alpha_omega_sigma * alpha_omega_raw;
  theta = alpha_theta_mu + alpha_theta_sigma * alpha_theta_raw;
  sigma = alpha_sigma_mu + alpha_sigma_sigma * alpha_sigma_raw;
}

model {
    alpha_ult_mu ~ normal(5000, 1000);
    alpha_ult_sigma ~ student_t(3, 100, 20);
    alpha_ult_raw ~ std_normal();

    alpha_omega_mu ~ normal(1, 2);
    alpha_omega_sigma ~ student_t(3, 0.3, 0.1);
    alpha_omega_raw ~ std_normal();

    alpha_theta_mu ~ normal(45, 10);
    alpha_theta_sigma ~ student_t(3, 7.5, 1.5);
    alpha_theta_raw ~ std_normal();

    alpha_sigma_mu ~ student_t(3, 250, 75);
    alpha_sigma_sigma ~ student_t(3, 25, 5);
    alpha_sigma_raw ~ std_normal();

    for (i in 1:N) {
        real mu = cum_loss(
            dev[i], ult[AY[i]], omega, theta
        );
        cum[i] ~ normal(mu, sigma);
    }
}

generated quantities {
    vector[N] cum_pred = to_vector(cum);

    for (i in 1:N) {
        real mu = cum_loss(
            dev[i], ult[AY[i]], omega, theta
        );
        cum_pred[i] = normal_rng(mu, sigma); 
    }
}

