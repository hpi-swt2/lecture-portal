echo "Currently running a $TRAVIS_EVENT_TYPE"
if [ "$TRAVIS_BRANCH" = "master" ]
then 
	export APP="hpi-lectureportal"; 
elif [ "$TRAVIS_BRANCH" = "dev" ]
then 
	export APP="hpi-lectureportal-dev"; 
else
	echo "No deployment on branch $TRAVIS_BRANCH";
	exit 0;
fi
echo "$APIKEY" | docker login $REGISTRY -u $USERNAME --password-stdin
HEROKU_API_KEY="$APIKEY" heroku container:push --app $APP --arg secret=${SECRET} web
HEROKU_API_KEY="$APIKEY" heroku container:release --app $APP web
