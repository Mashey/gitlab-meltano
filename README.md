### .env Setup
Create a `.env` file within the root directory of the project with the following format:
```
TAP_SLACK_TOKEN="<SLACK_TOKEN>"

SF_ACCOUNT="<ACCOUNT>"
SF_USER="<USER>"
SF_PASSWORD="<PASSWORD>"
SF_ROLE="<ROLE>"       # in UPPERCASE
SF_DATABASE="<DATABASE>"   # in UPPERCASE
SF_WAREHOUSE="<WAREHOUSE>"  # in UPPERCASE
```

### Scheduling
To run the scheduler, run the following command
```
docker run -v $(pwd):/projects -w /projects -e GOOGLE_APPLICATION_CREDENTIALS=client_secrets.json meltano/meltano invoke airflow scheduler
```