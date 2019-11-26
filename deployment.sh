echo "Currently running a $TRAVIS_EVENT_TYPE"
if [ "$TRAVIS_EVENT_TYPE" = "pull_request" ]
then
	echo "Not deploying in a pull request!"
	exit 0;
fi
if [ "$TRAVIS_BRANCH" = "ab-continuous-deployment" ]
then 
	export APP="hpi-lectureportal"; 
elif [ "$TRAVIS_BRANCH" = "ab-continuous-deployment-multibranch" ]
then 
	export APP="hpi-lectureportal-dev"; 
else
	echo "No deployment on branch $TRAVIS_BRANCH";
	exit 0;
fi
echo "$APIKEY" | docker login $REGISTRY -u $USERNAME --password-stdin
HEROKU_API_KEY="$APIKEY" heroku container:push --app $APP --arg secret=${SECRET} web
HEROKU_API_KEY="$APIKEY" heroku container:release --app $APP web
