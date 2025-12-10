input <- c("987654321111111",
           "811111111111119",
           "234234234234278",
           "818181911112111")

split_bank <- function(bank) {
  batteries <- unlist(strsplit(bank, ""))
  batteries
}

max_joltage <- function(batteries) {
  n_batteries <- length(batteries)
  i_max_joltage_battery <- which.max(batteries[1:(n_batteries - 1)])
  remaining_batteries <- batteries[(i_max_joltage_battery + 1):n_batteries]
  i_snd_max_joltage_battery <- which.max(remaining_batteries)
  paste0(batteries[i_max_joltage_battery],
         remaining_batteries[i_snd_max_joltage_battery])
}

Map(function(x) (max_joltage(split_bank(x))), input) |>
  as.integer() |>
  sum()
