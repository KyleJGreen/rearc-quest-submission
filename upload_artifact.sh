export PROJECT_ID="rearc-quest-kgreen"
export REGION=us-central1
export REPO=quest
export IMAGE_NAME=quest-webapp
export IMAGE_URI="$REGION-docker.pkg.dev/$PROJECT_ID/$REPO/$IMAGE_NAME"

# build and push the Docker image to thhe registy
docker build -t $IMAGE_NAME .
docker tag $IMAGE_NAME $IMAGE_URI
gcloud config set project rearc-quest-kgreen
gcloud auth configure-docker $REGION-docker.pkg.dev
docker push $IMAGE_URI