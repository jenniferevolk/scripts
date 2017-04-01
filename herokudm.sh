#!/bin/sh
#herokudm.sh
#deploy and migrate heroku
#by Jennifer E Volk

heroku maintenance:on
git push heroku
heroku run rails db:migrate
heroku maintenance:off
