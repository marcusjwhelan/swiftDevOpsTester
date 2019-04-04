FROM postgres:11.2-alpine
VOLUME /var/lib/postgresql/data

COPY ./docker-entrypoint.sh /usr/local/bin/
RUN chmod +x docker-entrypoint.sh
RUN echo "listen_addresses='*'"
# ENTRYPOINT ["docker-entrypoint.sh"]

#EXPOSE 5432
CMD ["postgres"]