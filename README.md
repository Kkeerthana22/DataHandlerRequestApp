Developer org login details:
username:keerthana.karnati2@validify.challenge
emailId:karnatikeerthana22@gmail.com
password:Salesforce@111
Profile:System Administrator

RESTPOINT:
GET-To provide the ID to fetch the particular record
HTTPOST-To provide the JSONpayload data as a body

Authentication information:
Connected app: -NodeJSInt

Callback URL:
https://your-nodejs-app.com/oauth/callback

Consumer Key:
3MVG9WVXk15qiz1JyKlc_RN3St7JRxcaFLI6Iq2LdW3uu6OXBZ5ywD7E54NmW1YxYRN86H_mNIG.2FYgAPm31
Consumer Secret:	
1ED9B7E7DEC60BC54BD9F52846327B551643EE4576BC509701136E2DB434464E

Selected OAuth Scopes:	
Manage user data via APIs (api)
Manage user data via Web browsers (web)
Full access (full)
Access Connect REST API resources (chatter_api)
Access unique user identifiers (openid)

Implementation overview:
1.Created a connected app named -NodeJSInt.
2.Created a single custom object companyData__c with the required custom fields to handle the incoming data of customers,payments,referrals and other datasubsets to support a scalable integration connection.
3.Created recordtypes and pagelayouts for customer,payments,referral inorder to differentiate the customer,payment,referral records.
4.Created an Apex REST service handler class to handle inbound requests for HTTPGET and HTTPOST methods and created a wrapper class  to processes the incoming bulk data loads and for future scope.
5.Assigned the records to related recordtypes inorder to have a structered data.
6.Tested the requests and responses with POSTMAN(GET,POST) for multiple JSON payloads of customer,payments,referrals
