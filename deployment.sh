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
#script by travis that will take care of deployment (but needs alpha features)
gem install dpl --pre
if dpl heroku git --api_key ${$APIKEY} --app $APP;
then
  HEROKU_API_KEY="$APIKEY" heroku container:release --app $APP web
else
  echo "Docker build failed!"
  exit 1
fi