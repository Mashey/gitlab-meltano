### .env Setup
Create a `.env` file within the root directory of the project with the following format:
```
TAP_SLACK_TOKEN="<SLACK_TOKEN>"

SF_USER="<USER>"
SF_PASSWORD="<PASSWORD>"
```

### Scheduling
To run the scheduler, run the following command
```
docker run -v $(pwd):/projects -w /projects meltano/meltano invoke airflow scheduler
```