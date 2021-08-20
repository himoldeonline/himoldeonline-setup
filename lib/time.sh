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

_get_time_of_day_plus_x_minutes () {
  # 1st arg: minute count
  date --date="+$1 minutes" +"%H:%M"
}
