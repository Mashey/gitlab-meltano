### Slack Setup
In order for the Slack data extraction to work, you need to [create a Slack app](https://api.slack.com/apps/) with the following scopes:
```
channels:history
channels:join
channels:read
files:read
groups:history
groups:read
links:read
pins:read
reactions:read
remote_files:read
team:read
usergroups:read
users.profile:read
users:read
users:read.email
```
Once the app has been installed in your workplace, keep note of the slack `verification token` for the environment setup below.

If you wish to get data from private channels, you must invite the bot to all private channels you wish to ingest.

---
### Zoom Setup
With an account that has admin privileges, [create a JWT app](https://marketplace.zoom.us/develop/create). During the setup, you must set the expiration of the JWT key. Since this app is scheduled to constantly run, it is recommended to set the expiration date as far in the future as your company will allow.

---

### Meltano Setup
Before you can run any Meltano commands, run the following command to install your environment:
```
meltano install
```

Once installed, you may run any command from the [Meltano CLI](https://meltano.com/docs/command-line-interface.html)

In order for the installed Meltano taps to function properly, the following environment varaiables must be set:
```
SF_USER="<USER>"
SF_PASSWORD="<PASSWORD>"

TAP_SLACK_TOKEN="<SLACK VERIFICATION TOKEN>"

TAP_ZOOM_JWT="<JWT KEY>"
```

The easiest way to set these environment variables is to make a `.env` file with the necessary credentials in the root directory. 

When running in production, you can just set your production environment variables or 

---

### Scheduling
Scheduling is handled with built-in [Airflow](https://airflow.apache.org/). To run the scheduler, run the following command
```
meltano invoke airflow scheduler
```