echo "Currently running a $TRAVIS_EVENT_TYPE"
if [ "$TRAVIS_BRANCH" = "master" ]
then 
	export APP="hpi-lectureportal"; 
elif [ "$TRAVIS_BRANCH" = "fix/cd" ]
then 
	export APP="hpi-lectureportal-dev"; 
else
	echo "No deployment on branch $TRAVIS_BRANCH";
	exit 0
fi
#cleaner than vanilla docker command
HEROKU_API_KEY="$APIKEY" heroku container:login
#herokucli always exits with 0, even if docker build failed, so build using vanilla docker command
if sh -c ./build.sh;
then
  #so the previously built image can be used and heroku does not build it a second time
  docker tag rails registry.heroku.com/${APP}/web:latest
  HEROKU_API_KEY="$APIKEY" heroku container:push --app $APP --arg secret=${SECRET} web
  HEROKU_API_KEY="$APIKEY" heroku container:release --app $APP web
else
  echo "Docker build failed!"
  exit 1