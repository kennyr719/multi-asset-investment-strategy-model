# Portfolio analysis helpers. Thin wrappers over IntroCompFinR's optimization
# primitives for the computations repeated throughout the report.

annualize_sharpe <- function(monthly_er, monthly_sd, rf_annual) {
  (monthly_er * 12 - rf_annual) / (monthly_sd * sqrt(12))
}

portfolio_summary <- function(port, rf_annual) {
  list(
    monthly_er     = port$er,
    monthly_sd     = port$sd,
    annual_sharpe  = annualize_sharpe(port$er, port$sd, rf_annual),
    weights        = port$weights
  )
}
