FROM apiman/on-wildfly10:latest

RUN $JBOSS_HOME/bin/add-user.sh admin admin123! --silent

# Apiman properties
ADD apiman.properties $JBOSS_HOME/standalone/configuration/


# Postgres
ENV DB_CONNECTOR_VERSION 9.4-1201-jdbc41
RUN rm $JBOSS_HOME/standalone/deployments/apiman-ds.xml
RUN mkdir -p $JBOSS_HOME/modules/system/layers/base/org/postgresql/jdbc/main; cd $JBOSS_HOME/modules/system/layers/base/org/postgresql/jdbc/main; curl -O http://central.maven.org/maven2/org/postgresql/postgresql/$DB_CONNECTOR_VERSION/postgresql-$DB_CONNECTOR_VERSION.jar
ADD module.xml $JBOSS_HOME/modules/system/layers/base/org/postgresql/jdbc/main/


# Add standalone-apiman.xml
ADD standalone-apiman.xml $JBOSS_HOME/standalone/configuration/


# Disable builtin Elasticsearch
RUN rm -f $JBOSS_HOME/standalone/deployments/apiman-es*


# Default wildfly debug port  
EXPOSE 8787

CMD ["/opt/jboss/wildfly/bin/standalone.sh", "-b", "0.0.0.0", "-bmanagement", "0.0.0.0", "-c", "standalone-apiman.xml", "--debug"]