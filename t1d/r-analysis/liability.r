library(pROC) # to get AUC values

R2O = 0.001829 # observed R2
K = 0.023800 # population prevalence
P = 0.009008 # proportion of cases in the case-control samples

obs_to_liab <- function(r2obs, P, K) {
  thd <- -qnorm(K, 0, 1)
  zv <- dnorm(thd) # z (normal density)
  m <- zv / K # mean liability for case

  theta <- m * (P - K) / (1 - K) * (m * (P - K) / (1 - K) - thd)
  C <- K * (1 - K) / zv^2 * K * (1 - K) / (P * (1 - P))
  r2liab <- r2obs * C / (1 + r2obs * theta * C)

  return(r2liab)
}

R2 <- obs_to_liab(R2O, P, K)

print(R2)
