#!/bin/bash

echo "Copying ovaledge.war file"
cp /root/temp/ovaledge.war /usr/local/tomcat/webapps/ovaledge.war
rm -r /usr/local/tomcat/webapps/ROOT
#mv /usr/local/tomcat/webapps/ovaledge.war /usr/local/tomcat/webapps/ROOT.war
#echo "ovaledge.war file copied as ROOT.war to /usr/local/tomcat/webapps/"

echo "Copying catalina.properties file"
rm -r /usr/local/tomcat/conf/catalina.properties
cp /root/temp/catalina.properties  /usr/local/tomcat/conf/catalina.properties
#echo "catalina.properties file copied to /usr/local/tomcat/conf/catalina.properties"



echo "#local DB Crendentials.
driverClassName=com.mysql.jdbc.Driver
security_type=$OVALEDGE_SECURITY_TYPE
url=$OVALEDGE_MYSQL_URL
username=$OVALEDGE_MYSQL_USER
password=$OVALEDGE_MYSQL_PWORD
initialSize=2
ovaledge.role.public=OE_PUBLIC
samlHTTPMetadataProvider=$OVALEDGE_SAML_META_DATA
ldap.userSearchFilter=$LDAP_USER_SEARCH_FILTER
ldap.userSearchBase=$LDAP_USERSEARCHBASE
ldap.groupRoleAttribute=$LDAP_GROUPROLEATTRIBUTE
ldap.groupSearchFilter=$LDAP_GROUP_SEARCH_FILTER
ldap.groupSearchBase=$LDAP_GROUPSEARCHBASE
ldap.url=$LDAP_URL
ldap.managerDn=$LDAP_MANAGERDN
ldap.managerPassword=$LDAP_MANAGER_PWORD
ldap.rootDn=$LDAP_ROOTDN
ldap.customRolePrefix=OE
ldap.roles.source=ldap
ldap.usermapping.firstName=givenName
ldap.usermapping.lastName=sn
ldap.usermapping.email=mail
spring.security.oauth2.client.registration.google.clientId=clientId
spring.security.oauth2.client.registration.google.clientSecret=clientSecret
spring.security.oauth2.client.registration=google
saml-metadata-type=$SAML_METADATA_TYPE
entity-base-islb=$ENTITY_BASE_ISLB
entity-base-protocol=$ENTITY_BASE_PROTOCOL
entity-base-host=$ENTITY_BASE_HOST
entity-base-port=$ENTITY_BASE_PORT
entity-base-contextpath=$ENTITY_BASE_CONTEXTPATH
entityBaseURL=$ENTITY_BASE_URL
#Elasticsearch configurations.
es.host=localhost
es.port=9200
es.protocol=http
es.username=admim
es.password=admin
entity-base-port-in-url=$ENTITY_BASE_PORT_INURL" > /usr/local/tomcat/conf/oasis.properties

if [ -z ${OVALEDGE_SECURITY_TYPE+x} ]; then
    OVALEDGE_SECURITY_TYPE="db";
fi
echo "OVALEDGE_SECURITY_TYPE will be '${OVALEDGE_SECURITY_TYPE}'"

# Cleanup temp files
rm -r /root/temp



echo "export CATALINA_OPTS=\"-DOVALEDGE_SECURITY_TYPE=$OVALEDGE_SECURITY_TYPE $OVALEDGE_ENVT_VAR\"" > /usr/local/tomcat/bin/setenv.sh
if [ -z ${JAVA_OPTS+x} ]; then
    export JAVA_OPTS="-Dfile.encoding=UTF-8 -server -Xms256m -Xmx1024m";
fi

echo "JAVA Memory is '${JAVA_OPTS}'"


keytool -importcert -alias pftrustca -file /usr/local/tomcat/conf/saml/PF-OvalEdge1.cer -keystore /usr/local/tomcat/conf/saml/keystore.jks -storepass secret -noprompt


# Run tomcat
catalina.sh run
