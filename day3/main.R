test_input <- c("987654321111111",
                "811111111111119",
                "234234234234278",
                "818181911112111")

split_bank <- function(bank) {
  # split banks into list of batteries
  batteries <- unlist(strsplit(bank, ""))
  batteries
}

max_joltage <- function(remaining_bats, selected_bats, n_bats_left) {
  # find sequence of (n_bats_left+1) batteries that produce max joltage
  if (n_bats_left == 0) {
    cur_n_bats <- length(remaining_bats)
    i_max_bat <- which.max(remaining_bats[1:(cur_n_bats - n_bats_left)])
    paste0(c(selected_bats, remaining_bats[i_max_bat]), collapse = "")
  } else {
    cur_n_bats <- length(remaining_bats)
    i_max_bat <- which.max(remaining_bats[1:(cur_n_bats - n_bats_left)])
    cur_remaining_bats <- remaining_bats[(i_max_bat + 1):cur_n_bats]
    cur_selected_bats <- c(selected_bats, remaining_bats[i_max_bat])
    max_joltage(cur_remaining_bats, cur_selected_bats, n_bats_left - 1)
  }
}

# read input data from txt
data <- scan("data.txt", what = "character")

#### solve task and print to console ####
# part 1
Map(function(x) (max_joltage(split_bank(x), c(), 1)), data) |>
  as.numeric() |>
  sum() |>
  format(scientific = FALSE)

# part 2
Map(function(x) (max_joltage(split_bank(x), c(), 11)), data) |>
  as.numeric() |>
  sum() |>
  format(scientific = FALSE)
