library(data.table)

# test input data
dt <- data.table::data.table(
  sex = rep("both", 4),
  age_start = c(0, 5, 10, 15),
  age_end = c(5, 10, 15, Inf),
  age_length = c(5, 5, 5, 120),
  mx = c(0.1, 0.2, 0.3, 0.4),
  ax = c(2.5, 2.5, 2.5, 2.5)
)
dt[, qx := mx_ax_to_qx(mx, ax, age_length)]

param_cols <- c("mx", "ax", "qx", "px",
                "lx", "dx", "nLx",
                "Tx", "ex")

test_that("test that `lifetable` gives expected output", {
  dt <- lifetable(dt, id_cols = c("age_start", "age_end", "sex"))
  testthat::expect_equal(T, setequal(names(dt),
                                c("sex", "age_start", "age_end", "age_length",
                                  param_cols)))
  assertable::assert_values(dt, param_cols, "not_na", quiet = T)
})

test_that("test that `lifetable` works when missing ax", {
  dt_no_ax <- dt[, .(sex, age_start, age_end, age_length, mx, qx)]
  dt <- lifetable(dt_no_ax, id_cols = c("age_start", "age_end", "sex"))
  testthat::expect_equal(T, setequal(names(dt),
                                     c("sex", "age_start", "age_end",
                                       "age_length", param_cols)))
  assertable::assert_values(dt, param_cols, "not_na", quiet = T)
})

test_that("test that `lifetable` works when missing mx", {
  dt_no_mx <- dt[, .(sex, age_start, age_end, age_length, ax, qx)]
  dt <- lifetable(dt_no_mx, id_cols = c("age_start", "age_end", "sex"))
  testthat::expect_equal(T, setequal(names(dt),
                                     c("sex", "age_start", "age_end",
                                       "age_length", param_cols)))
  assertable::assert_values(dt, param_cols, "not_na", quiet = T)
})

test_that("test that `lifetable` works when missing qx", {
  dt_no_qx <- dt[, .(sex, age_start, age_end, age_length, mx, ax)]
  dt <- lifetable(dt_no_qx, id_cols = c("age_start", "age_end", "sex"))
  testthat::expect_equal(T, setequal(names(dt),
                                     c("sex", "age_start", "age_end",
                                       "age_length", param_cols)))
  assertable::assert_values(dt, param_cols, "not_na", quiet = T)
})

test_that("test that `lifetable` with long format works", {
  dt <- lifetable(dt, id_cols = c("age_start", "age_end", "sex"), format_long = T)
  testthat::expect_equal(
    sort(names(dt)),
    sort(c("sex", "age_start", "age_end", "age_length",
           "life_table_parameter", "value"))
  )
})
