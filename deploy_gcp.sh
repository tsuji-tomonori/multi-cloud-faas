export ORG_GRADLE_PROJECT_ARCHIVECLASSIFIER="gcp"
./gradlew clean
./gradlew build
rm build/libs/demo-function-0.0.1-SNAPSHOT.jar
gcloud functions deploy function-sample-gcp-http-01 \
    --entry-point org.springframework.cloud.function.adapter.gcp.GcfJarLauncher \
    --runtime java17 \
    --trigger-http \
    --source build/libs \
    --memory 512MB