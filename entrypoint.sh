#!/usr/bin/env bash

cd /projects

# meltano config meltano set database_uri "postgresql://postgres:OniFbN6Jwbucr5MI@/meltano-meta?host=/cloudsql/gadmin-reports-294123:us-central1:gitlab"
# meltano invoke airflow upgradedb
# meltano config airflow list
meltano invoke airflow scheduler
