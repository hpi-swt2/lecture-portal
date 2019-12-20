echo "Currently running a $TRAVIS_EVENT_TYPE"
if [ "$TRAVIS_BRANCH" = "master" ]
then 
	export APP="hpi-lectureportal"; 
elif [ "$TRAVIS_BRANCH" = "build-on-heroku" ]
then 
	export APP="hpi-lectureportal-dev"; 
else
	echo "No deployment on branch $TRAVIS_BRANCH";
	exit 0
fi
#cleaner than vanilla docker command
HEROKU_API_KEY="$APIKEY" heroku container:login
HEROKU_API_KEY="$APIKEY" heroku git:remote --app ${APP}
#herokucli always exits with 0, even if docker build failed, so build using vanilla docker command
if git push heroku $TRAVIS_BRANCH:master;
then
  HEROKU_API_KEY="$APIKEY" heroku container:release --app $APP web
else
  echo "Docker build failed!"
  exit 1
fi