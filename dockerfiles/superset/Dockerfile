FROM apache/superset:402c29c-dev

ARG APP_VERSION

ARG BUILD_DATE

LABEL maintainer=james.bristow@plantandfood.co.nz

LABEL org.label-schema.build-date=$BUILD_DATE

LABEL version=$APP_VERSION

ENV ADMIN_USERNAME $ADMIN_USERNAME

ENV ADMIN_EMAIL $ADMIN_EMAIL

ENV ADMIN_PASSWORD $ADMIN_PASSWORD

ENV SUPERSET_CONFIG_PATH /app/superset_config.py

USER root

COPY --chown=superset:superset --chmod=755 ./services/superset/superset-init.sh /superset-init.sh

COPY --chown=superset:superset --chmod=755 ./services/superset/superset_config.py /app/

RUN chmod +x /superset-init.sh \
    && chown superset /superset-init.sh \
    && chmod +x /app/superset_config.py \
    && chown superset /app/superset_config.py

USER superset

ENTRYPOINT [ "/superset-init.sh" ]
