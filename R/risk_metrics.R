# Value-at-Risk and bootstrap Sharpe ratio functions used in the report.
# Requires: boot

Value.at.Risk <- function(x, p = 0.05, w = 100000,
                          method = c("normal", "empirical"),
                          return.type = c("cc", "simple")) {
  method <- method[1]
  return.type <- return.type[1]
  x <- as.matrix(x)
  if (method == "normal") {
    q <- apply(x, 2, mean) + apply(x, 2, sd) * qnorm(p)
  } else {
    q <- apply(x, 2, quantile, p)
  }
  if (return.type == "simple") {
    VaR <- q * w
  } else {
    VaR <- (exp(q) - 1) * w
  }
  VaR
}

ValueAtRisk.boot <- function(x, idx, p = 0.05, w = 100000,
                             method = c("normal", "empirical"),
                             return.type = c("cc", "simple")) {
  method <- method[1]
  return.type <- return.type[1]
  if (method == "normal") {
    q <- mean(x[idx]) + sd(x[idx]) * qnorm(p)
  } else {
    q <- quantile(x[idx], p)
  }
  if (return.type == "cc") {
    VaR <- (exp(q) - 1) * w
  } else {
    VaR <- q * w
  }
  VaR
}

computeSEconfintVaR <- function(x, p = 0.05, w = 100000,
                                method = c("normal", "empirical"),
                                return.type = c("cc", "simple")) {
  VaR.boot <- boot::boot(x, statistic = ValueAtRisk.boot, p = p, R = 999)
  VaR.hat <- VaR.boot$t0
  SE.VaR <- sd(VaR.boot$t)
  CI.VaR <- boot::boot.ci(VaR.boot, conf = 0.95, type = "norm")$normal
  CI.VaR <- CI.VaR[-1]
  ans <- c(VaR.hat, SE.VaR, CI.VaR)
  names(ans) <- c("VaR", "SE", "LCL (0.95)", "UCL (0.95)")
  ans
}

sharpeRatio.boot <- function(x, idx, risk.free) {
  muhat <- mean(x[idx])
  sigmahat <- sd(x[idx])
  (muhat - risk.free) / sigmahat
}

computeSEconfintSharpe <- function(x, risk.free) {
  Sharpe.boot <- boot::boot(x, statistic = sharpeRatio.boot, R = 999, risk.free = risk.free)
  Sharpe.hat <- Sharpe.boot$t0
  SE.Sharpe <- sd(Sharpe.boot$t)
  CI.Sharpe <- boot::boot.ci(Sharpe.boot, conf = 0.95, type = "norm")$normal
  CI.Sharpe <- CI.Sharpe[-1]
  ans <- c(Sharpe.hat, SE.Sharpe, CI.Sharpe)
  names(ans) <- c("Sharpe", "SE", "LCL (0.95)", "UCL (0.95)")
  ans
}
