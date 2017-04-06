FROM jboss/wildfly:9.0.2.Final

ENV APIMAN_VERSION 1.2.1.Final

RUN cd $JBOSS_HOME \
 && curl http://downloads.jboss.org/overlord/apiman/$APIMAN_VERSION/apiman-distro-wildfly9-$APIMAN_VERSION-overlay.zip -o apiman-distro-wildfly9-$APIMAN_VERSION-overlay.zip \
 && bsdtar -xf apiman-distro-wildfly9-$APIMAN_VERSION-overlay.zip \
 && rm apiman-distro-wildfly9-$APIMAN_VERSION-overlay.zip

RUN $JBOSS_HOME/bin/add-user.sh admin admin123! --silent

# Add the postgres driver and datasource
ADD files/* /opt/jboss/wildfly/standalone/deployments/
# Change standalone-apiman.xml for postgres
RUN  sed -i -e 's/H2Dialect/PostgreSQLDialect/g' $JBOSS_HOME/standalone/configuration/standalone-apiman.xml
RUN  sed -i -e 's/H2Dialect/PostgreSQLDialect/g' $JBOSS_HOME/standalone/configuration/apiman.properties


ENTRYPOINT ["/opt/jboss/wildfly/bin/standalone.sh", "-b", "0.0.0.0", "-c", "standalone-apiman.xml"]
