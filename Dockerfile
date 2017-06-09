FROM vapor/vapor

# Check if we should install mysql header files to the container (Defualt: false)
ARG INSTALL_MYSQL=false
RUN if [ ${INSTALL_MYSQL} = true ]; then \
    apt-get update && \
        apt-get install -y libmysqlclient20 libmysqlclient-dev && \
	    rm -r /var/lib/apt/lists/* \
	     ;fi

# Check if we should install postgres header files to the container (Defualt: false)
ARG INSTALL_PGSQL=false
RUN if [ ${INSTALL_PGSQL} = true ]; then \
      apt-get update && \
            apt-get install -y libpq-dev && \
	          rm -r /var/lib/apt/lists/* \
		  ;fi

# Check if we should install sqlite header files to the container (Defualt: false)
ARG INSTALL_SQLITE=false
RUN if [ ${INSTALL_SQLITE} = true ]; then \
      apt-get update && \
            apt-get install -y libsqlite3-dev && \
	          rm -r /var/lib/apt/lists/* \
		  ;fi


RUN mkdir -p /vapor
WORKDIR /vapor
COPY . /vapor
RUN vapor build
CMD ["vapor",  "run"]
EXPOSE 8081