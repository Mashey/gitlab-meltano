# Table of Contents
* [Preparing Meltano](#preparing_meltano)
    * [Gmail Setup](#tap_gmail_setup)
    * [Slack Setup](#tap_slack_setup)
    * [Zoom Setup](#tap_zoom_setup)
    * [Meltano Setup](#meltano_setup)
    * [Running the Scheduler](#scheduler)
* [Preparing Meltano](#preparing_for_production)
    * [Dockerize the Project](#dockerization)

# <a name="preparing_meltano"></a>Preparing Meltano
Below is a guide on how to set up the Meltano project. Currently these are the taps/targets installed:
* [Tap Gmail](https://github.com/Mashey/tap-gmail)
* [Tap Slack](https://github.com/Mashey/tap-slack)
* [Tap Zoom](https://github.com/Mashey/tap-zoom)
* [Target Snowflake](https://meltano.com/plugins/loaders/snowflake--meltano.html#snowflake-meltano-variant)

Setup of these taps/targets must be completed before this Meltano project can be ran.
### <a name="tap_gmail_setup"></a>Gmail Setup

Due to the current implementation of [tap-gmail](https://github.com/Mashey/tap-gmail) in which it is tailored to GitLab, fork this repository in order to ensure changes to this repository do not arise unexpectedly.

The Google API Python Client documentation provides a guide for completing all necessary steps to ensure the application and environment are configured correclty. The guide can be found here:

[Using OAuth 2.0 for Server to Server Applications](https://github.com/googleapis/google-api-python-client/blob/master/docs/oauth-server.md)

The key steps in the guide are:

- Creating a service account.
- Delegating domain-wide authority to the service account.
- Create and download a `json` [service account key](https://cloud.google.com/iam/docs/creating-managing-service-account-keys#creating_service_account_keys) under the newly-created service account.

---
### <a name="tap_slack_setup"></a>Slack Setup
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

**Note:**
If you wish to get data from private channels, you must invite the bot to all private channels you wish to ingest.

---
### <a name="tap_zoom_setup"></a>Zoom Setup
With an account that has admin privileges, [create a JWT app](https://marketplace.zoom.us/develop/create). During the setup, you must set the expiration of the JWT key. Since this app is scheduled to constantly run, it is recommended to set the expiration date as far in the future as your company will allow.

---

### <a name="meltano_setup"></a>Meltano Setup
The following sections must be changed in the `meltano.yml` file before installation:
* Change the `pip_url` under `tap-gmail` to `git+https://your-service.com/organization/your-repo.git`
* Under the `settings` of `tap-slack`, change the value of `start_date` to a date you wish to sync from.
* Under the `config` of `target-snowflake`, change `account`, `database`, `warehouse`, and `role` to your respective settings. For more information on the specific settings, read the [Meltano Snowflake documentation](https://meltano.com/plugins/loaders/snowflake--meltano.html)

Once the above settings are changed, run the following command to install your environment:
```sh
# Without Docker
meltano install

# With Docker
docker run -v $(pwd):/projects -w /projects meltano/meltano:latest-python3.8 install
```

In order for the installed Meltano taps to function properly, the following [environment varaiables](https://en.wikipedia.org/wiki/Environment_variable) must be set:
```
SF_USER="<USER>"
SF_PASSWORD="<PASSWORD>"

TAP_SLACK_TOKEN="<SLACK VERIFICATION TOKEN>"

TAP_ZOOM_JWT="<JWT KEY>"

ADMIN_SDK_KEY="/path/to/service_key.json"
```

For local development, the easiest way to set these environment variables is to make a `.env` file with the necessary credentials in the root directory. 

Once installed and the environment variables have been set up, you may run any command from the [Meltano CLI](https://meltano.com/docs/command-line-interface.html)


---

### <a name="scheduler"></a>Running the Scheduler
Scheduling is handled with Meltano's built-in [Airflow](https://airflow.apache.org/). Currently, each tap is scheduled to sync every day. If you wish to change the frequency of individual syncs, you can change the value of `interval` under the `schedules` section within `meltano.yml`. Refer to the [Meltano documentation](https://meltano.com/docs/command-line-interface.html#how-to-use-7) for presets and valid intervals.

To run the scheduler, run the following command
```sh
# Without Docker
meltano invoke airflow scheduler

# With Docker
docker run -v $(pwd):/projects -w /projects meltano/meltano:latest-python3.8 invoke airflow scheduler
```

---


# <a name="preparing_for_production"></a>Preparing Meltano for Production
Below are the steps to get your Meltano project ready for production

---
### <a name="dockerization"></a>Dockerize the Project
Once the taps have been set up and the `meltano.yml` file has been changed, you can create a docker image to get ready for deployment to production. The provided `Dockerfile` will build the image and start up the Meltano Scheduler. 

To build the image, run the following command in the root directory:
```sh
docker build --tag <IMAGE NAME>:<TAG NAME> .
```