@RestResource(urlMapping='/companyManager/*')
global class CompanyDataManagerService {
   @HttpGET
    global static List<companyData__c> getCompanyData(){
         RestRequest req = RestContext.request;
         String companyDataId = req.requestURI.substring(req.requestURI.lastIndexOf('/') + 1);        
         try{
            List<companyData__c> CompanyInfo = [select id,first_name__c,last_name__c,phone__c,email__c,payment_method__c, referral_code__c, Customer__c, Payment__c, Referral__c, customer_id__c, Last_4_Digits_of_Credit_Card__c, referred_on__c, referrer_by__c, last_payment_date__c, id__c, Payment_Id__c FROM companyData__c];
            for (companyData__c Comp : companyInfo) {
            	System.debug('Fetched companyData__c record Id: ' + Comp.Id);
            }
         return CompanyInfo;
        }
		catch (Exception e) {
                     throw new AuraHandledException('Error Fetching  Data: ' + e.getMessage());
        }
  }

    @HttpPost 
    global static void createData(){
        try{   
            RestRequest req = RestContext.request;
            RestResponse res = RestContext.response;
            String CompanyJSONdata = req.requestBody.toString();
            System.debug('Request Body: ' + companyJSONdata);
            CompanyWrap enc = (CompanyWrap)JSON.deserialize(companyJSONdata, CompanyWrap.class);
            
            // To Process customers data
            if (enc.customers != null && !enc.customers.isEmpty()) {
                List<companyData__c> customerData = new List<companyData__c>();
                Id recordTypeId;
                //To assign related recordtype for customers
                string recordtypename = 'Customer';
                list<RecordType> rec =[select ID from RecordType where DeveloperName = :recordTypeName LIMIT 1 ];
                if(!rec.isEmpty()) {
  			   	recordTypeId = rec[0].Id;	
                }
                else{
                    system.debug('no recordType name found for this '+recordTypeName);
                }
                for (Customers cust : enc.customers) {
                        companyData__c ct = new companyData__c();
                    	ct.RecordTypeId = recordTypeId;
                        ct.id__c=cust.id;
                        ct.first_name__c = cust.first_name;
                        ct.last_name__c = cust.last_name;
                        ct.phone__c  = cust.phone;
                        ct.email__c = cust.email;
                        
                    	customerData.add(ct);
                    }
                 if (!customerData.isEmpty()) {
                        insert customerData;
                        System.debug('Inserted ' + customerData.size() + ' customer records.');
                    }
               }
                
              //To process payments data
              if (enc.payments != null && !enc.payments.isEmpty()) {
                    List<companyData__c> paymentData = new List<companyData__c>();
                    Id recordTypeId;
                    //To assign related recordtype for Payments
                    string recordtypename = 'Payment';
                    list<RecordType> rec =[select ID from RecordType where DeveloperName = :recordTypeName LIMIT 1 ];
                    if(!rec.isEmpty()) {
                    recordTypeId = rec[0].Id;	
                    }
                    else{
                        system.debug('no recordType name found for this '+recordTypeName);
                    }
                    for (Payments pay : enc.payments) {
                        companyData__c pt = new companyData__c();
                        pt.RecordTypeId = recordTypeId;
                        pt.Payment_Id__c=pay.id;
                        pt.customer_id__c  = pay.customer_id;
                        pt.last_payment_date__c =pay.last_payment_date;
                        pt.payment_method__c = pay.payment_method;
                        pt.Last_4_Digits_of_Credit_Card__c = pay.last_4_cc_digits;
                        
                        paymentData.add(pt);
                   }
                   if (!paymentData.isEmpty()) {
                        insert paymentData;
                        System.debug('Inserted ' + paymentData.size() + ' payment records.');
                  }
              }
             
            //To process Referral Data
            if (enc.referrals != null && !enc.referrals.isEmpty()) {
                 List<companyData__c> referralData = new List<companyData__c>();
                 Id recordTypeId;
                 //To assign related recordtype for Referrals
                 string recordtypename = 'Referrals';
                 list<RecordType> rec =[select ID from RecordType where DeveloperName = :recordTypeName LIMIT 1 ];
                 if(!rec.isEmpty()) {
                  recordTypeId = rec[0].Id;	
                 }
                 else{
                     system.debug('no recordType name found for this '+recordTypeName);
                    }
                 for (Referrals refer : enc.referrals) {
                      companyData__c ref  = new companyData__c();
                        ref.RecordTypeId = recordTypeId;
                        ref.id__c=refer.id;
                        ref.first_name__c = refer.first_name;
                        ref.last_name__c = refer.last_name;
                        ref.referred_on__c = refer.referred_on;
                        ref.referrer_by__c= refer.reffered_by;
                                        
                        referralData.add(ref);
                   }
                  if (!referralData.isEmpty()) {
                        insert referralData;
                        System.debug('Inserted ' + referralData.size() + ' customer records.');
                   }
               }        
            res.statusCode = 200;
            res.responseBody = Blob.valueOf('Response successfully processed and created records.');
        }
        catch (Exception e) {
           throw new AuraHandledException('Error Fetching  Data: ' + e.getMessage());
        }   
    }

      
       
public class CompanyWrap {
		public List<Customers> customers;
    	public List<Payments> payments;
    	public List<Referrals> referrals;
}
public class Customers {
		public Integer id;
		public String first_name;
		public String last_name;
		public String phone;
		public String email;
	}
global class Payments {
		global String id;
		global Integer customer_id;
		global String last_payment_date;
		global String payment_method;
		global Integer last_4_cc_digits;
	}
  global class Referrals {
		global Integer id;
		global String first_name;
		global String last_name;
		global String referred_on;
		global Integer reffered_by;
	}

        
    
}