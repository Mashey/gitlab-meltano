ARG MELTANO_IMAGE=meltano/meltano:latest-python3.8
FROM $MELTANO_IMAGE

WORKDIR /projects

# Install any additional requirements
COPY ./requirements.txt . 
RUN pip install -r requirements.txt

# Copy over remaining project files
COPY . .

# Install all plugins into the `.meltano` directory
COPY ./meltano.yml . 
RUN meltano install

# Pin `discovery.yml` manifest by copying cached version to project root
RUN cp -n .meltano/cache/discovery.yml . 2>/dev/null || :

# Don't allow changes to containerized project files
ENV MELTANO_PROJECT_READONLY 1

# Expose default port used by `meltano ui`
EXPOSE 5000

RUN chmod +x /projects/entrypoint.sh
ENTRYPOINT ["/projects/entrypoint.sh", "--port", "5000"]
