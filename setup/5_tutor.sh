_info_display ""  "run tutor"

# For when running multiple tutor commands

_tutor_from_scratch_build_dev () {
  # using our configurations, we build the images needed for running open edx dev
  # this will go through the steps equivalent to:
  # ..tutor local quickstart
  # ..tutor local stop
  # ..tutor images build openedx-dev
  tutor config save
  tutor local dc pull && sleep 2 || exit
  tutor local start --detach && sleep 2 || exit
  tutor local init && sleep 2 || exit
  tutor images build openedx && sleep 2 || exit
  tutor local stop && sleep 2 || exit
  tutor images build openedx-dev && sleep 2 || exit
  tutor dev start --detach && sleep 2 || exit
  tutor dev run lms pip install --requirement requirements/edx/development.txt && sleep 2
  tutor dev run lms npm install && sleep 2 || exit
  tutor dev run lms openedx-assets build --env=dev && sleep 2 || exit
}
