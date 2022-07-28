FROM python:3.10.5-slim-bullseye AS compile
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        python3-pip \
        python3-venv \ 
        python3-setuptools \
        gettext \
        build-essential \
        python3-dev \ 
        libffi-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

RUN pip3 install virtualenv
# Sets utf-8 encoding for Python
ENV LANG=C.UTF-8
# Turns off writing .pyc files. Superfluous on an ephemeral container.
ENV PYTHONDONTWRITEBYTECODE=1
# Seems to speed things up
ENV PYTHONUNBUFFERED=1

# Make sure we use the virtualenv:
ENV VIRTUAL_ENV=/opt/venv
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

RUN python3 -m venv $VIRTUAL_ENV
COPY requirements.txt ./requirements.txt
RUN pip3 install --no-cache-dir  -r requirements.txt


FROM python:3.10.5-slim-bullseye AS runner
# Sets utf-8 encoding for Python
ENV LANG=C.UTF-8
# Turns off writing .pyc files. Superfluous on an ephemeral container.
ENV PYTHONDONTWRITEBYTECODE=1
# Seems to speed things up
ENV PYTHONUNBUFFERED=1
# Make sure we use the virtualenv:
ENV PATH="/opt/venv/bin:$PATH"

WORKDIR /app
COPY makefileTemplates /app/makefileTemplates
COPY customStepsLibrary /app/customStepsLibrary
COPY makefiles /app/makefiles
COPY generalStepsLibrary /app/generalStepsLibrary
COPY main.py /app/main.py
ADD entrypoint.sh /app/entrypoint.sh

#Copy venv from builder image
COPY --from=compile /opt/venv /opt/venv


########
RUN mkdir /app/generatedMakefiles/ \
    && chown ${USER_UID}:${USER_UID} "/app" \
    && chown ${USER_UID}:${USER_UID} "/app/generatedMakefiles/"

RUN chmod -R 777 /app/generatedMakefiles/

USER ${USER_UID}

ENTRYPOINT ["/app/entrypoint.sh"]
