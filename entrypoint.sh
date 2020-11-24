#!/usr/bin/env bash

cd /projects

meltano invoke airflow scheduler -D

meltano ui