echo "Currently running a $TRAVIS_EVENT_TYPE"
if [ "$TRAVIS_BRANCH" = "master" ]
then 
	export APP="hpi-lectureportal"; 
elif [ "$TRAVIS_BRANCH" = "dev" ]
then 
	export APP="hpi-lectureportal-dev"; 
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
  #so the previously built image can be used and heroku does not build it a second time like if I called heroku container:push
  docker tag rails registry.heroku.com/${APP}/web:latest
  docker push registry.heroku.com/${APP}/web:latest
  HEROKU_API_KEY="$APIKEY" heroku container:release --app $APP web
else
  echo "Docker build failed!"
  exit 1
fi
