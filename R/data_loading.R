# Data loading helpers for the Multi-Asset Investment Strategy Model.
# Fetches adjusted closing prices from Yahoo Finance and aggregates to monthly.

load_etf_prices <- function(symbols, start_date, end_date) {
  raw <- quantmod::getSymbols(
    symbols, src = "yahoo",
    from = as.character(start_date),
    to = as.character(end_date),
    auto.assign = TRUE,
    warnings = FALSE
  )
  prices <- purrr::reduce(purrr::map(raw, ~ quantmod::Ad(get(.))), merge)
  colnames(prices) <- symbols
  xts::to.monthly(prices, OHLC = FALSE)
}
