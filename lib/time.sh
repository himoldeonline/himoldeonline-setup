# get timestamps in different formats

_get_time_of_year() {
  TIME_OF_YEAR=$(date +"%Y-%m-%d")
}

_get_unix_time () {
  TIME_UNIX=$(date +"%s")
}

_get_time_of_day () {
  TIME_OF_DAY=$(date +"%H:%M:%S")
}