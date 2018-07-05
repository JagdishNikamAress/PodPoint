public class helperCustomer 
{
   
    public HttpResponse createCustomer(String name,String accountName,String accountnumber, String billingStreet,String billingCity,String billingPostalCode,String billingcountry,String phone, String email)
    {
        if(name !=null && billingStreet !=null && billingCity !=null)
        {
            String Endpoint = 'https://api.fieldaware.net/customer/';
        	String Method = 'POST';
        
        
            //instantiate the generator
            JSONGenerator gen = JSON.createGenerator(true);
            gen.writeStartObject();
            if(name != null)
                gen.writeStringField('name', name);
            //gen.writeStringField('email', 'bdata@mailinator.com');
            if(phone != null && phone != '')
                gen.writeStringField('phone', phone);
            if(email != null && email != '')
                gen.writeStringField('email', email);	
            if(accountnumber != null && accountnumber != '')
                gen.writeStringField('account', accountnumber);	
            
            gen.writeFieldName('location');	     
            gen.writeStartObject();   
            gen.writeObjectField('name', accountName);	
            gen.writeObjectField('streetName', billingStreet);
            
            if(billingPostalCode != null || billingPostalCode != '')
            	gen.writeObjectField('postcode', billingPostalCode);	
            
            gen.writeObjectField('locality', billingCity);
            
            if(billingcountry != null)
            	gen.writeObjectField('country', billingcountry);	
            gen.writeEndObject();
        	
           

            String jsonString = gen.getAsString();
            system.debug('jsonCustomers' + jsonString);
            
            HttpResponse res = HttpRequestPOSTMethod(Endpoint,Method,jsonString);  
            return res; 
        }
        else
            return null;
           
    }
     
    
    public HttpResponse updateCustomer(String FieldAwareID, String name,String accountnumber, String billingStreet,String billingCity,String billingPostalCode,String billingcountry,String phone, String email)
    {
        if(name !=null && billingStreet !=null && billingCity !=null)
        {
            String Endpoint = 'https://api.fieldaware.net/customer/'+FieldAwareID;
        	String Method = 'PUT';
        
        
            //instantiate the generator
            JSONGenerator gen = JSON.createGenerator(true);
            gen.writeStartObject();
            if(name != null)
                gen.writeStringField('name', name);
            if(phone != null && phone != '')
                gen.writeStringField('phone', phone);
            if(email != null && email != '')
                gen.writeStringField('email', email);
            if(accountnumber != null && accountnumber != '')
                gen.writeStringField('account', accountnumber);
            

            String jsonString = gen.getAsString();
            system.debug('jsonCustomers' + jsonString);
            
            HttpResponse res = HttpRequestPOSTMethod(Endpoint,Method,jsonString);  
            return res; 
        }
        else
            return null;
           
    }
    
    public HttpResponse updateLocation(String FieldAwareID,String LocationID,String billingStreet,String billingCity,String billingPostalCode,String billingcountry)
    {
        if(billingStreet !=null && billingCity !=null)
        {
            String Endpoint = 'https://api.fieldaware.net/customer/'+FieldAwareID+'/location/'+LocationID;
        	String Method = 'PUT';
        
        
            //instantiate the generator
            JSONGenerator gen = JSON.createGenerator(true);
            gen.writeStartObject();
            if(billingStreet != null)
                gen.writeStringField('streetName', billingStreet);
            if(billingPostalCode != null && billingPostalCode != '')
                gen.writeStringField('postcode', billingPostalCode);	
            if(billingCity != null)
                gen.writeStringField('locality', billingCity);
            if(billingcountry != null)
                gen.writeStringField('country', billingcountry);


            String jsonString = gen.getAsString();
            system.debug('jsonCustomers' + jsonString);
            
            HttpResponse res = HttpRequestPOSTMethod(Endpoint,Method,jsonString);  
            return res; 
        }
        else
            return null;
           
    }
    
    public static void updateLocation_Static(String FieldAwareID,String LocationID,String billingStreet,String billingCity,String billingPostalCode,String billingcountry)
    {
        if(billingStreet !=null && billingCity !=null)
        {
            String Endpoint = 'https://api.fieldaware.net/customer/'+FieldAwareID+'/location/'+LocationID;
        	String Method = 'PUT';
        
        
            //instantiate the generator
            JSONGenerator gen = JSON.createGenerator(true);
            gen.writeStartObject();
            if(billingStreet != null)
                gen.writeStringField('streetName', billingStreet);
            if(billingPostalCode != null && billingPostalCode != '')
                gen.writeStringField('postcode', billingPostalCode);	
            if(billingCity != null)
                gen.writeStringField('locality', billingCity);
            if(billingcountry != null)
                gen.writeStringField('country', billingcountry);


            String jsonString = gen.getAsString();
            system.debug('jsonCustomers' + jsonString);
            
            HttpResponse res = HttpRequestPOSTMethod_Static(Endpoint,Method,jsonString);  
            
        }
           
    }
    
    public HttpResponse createLocation(String FieldAwareID,String LocationID,String billingStreet,String billingCity,String billingPostalCode,String billingcountry)
    {
        if(billingStreet !=null && billingCity !=null)
        {
            String Endpoint = 'https://api.fieldaware.net/customer/'+FieldAwareID+'/location/';
        	String Method = 'POST';
        
        
            //instantiate the generator
            JSONGenerator gen = JSON.createGenerator(true);
            gen.writeStartObject();
            if(billingStreet != null)
                gen.writeStringField('streetName', billingStreet);
            if(billingPostalCode != null && billingPostalCode != '')
                gen.writeStringField('postcode', billingPostalCode);	
            if(billingCity != null)
                gen.writeStringField('locality', billingCity);
            if(billingcountry != null)
                gen.writeStringField('country', billingcountry);


            String jsonString = gen.getAsString();
            system.debug('jsonCustomers' + jsonString);
            
            HttpResponse res = HttpRequestPOSTMethod(Endpoint,Method,jsonString);  
            return res; 
        }
        else
            return null;
           
    }
    
    public HttpResponse HttpRequestGETMethod(String Endpoint, String Method)
    {
        	String Token;
            FieldAwareServer__c fs = FieldAwareServer__c.getInstance(userinfo.getProfileId());
            Token = fs.Token__c;
        
        system.debug('Token :'+Token);
         	HttpRequest reqVariable = new HttpRequest();
        	reqVariable.setEndpoint(Endpoint);
            reqVariable.setMethod(Method);
        	reqVariable.setheader('Accept','application/json');	
			reqVariable.setHeader('Authorization', 'Token '+Token);
            system.debug('Req body :' +reqVariable);
            
            Http httpVariable = new Http();
            HttpResponse resVariableList = httpVariable.send(reqVariable);

            //String strjson = '{"Contacts":' + (String)resVariableList.getBody() + '}';
        
            system.debug('Req body Contacts:' +(String)resVariableList.getBody());
        
        	return resVariableList;
    }
    
    public HttpResponse HttpRequestPOSTMethod(String Endpoint, String Method, String Body)
    {
        	String Token;
            FieldAwareServer__c fs = FieldAwareServer__c.getInstance(userinfo.getProfileId());
            Token = fs.Token__c;
        
        system.debug('Token :'+Token);
         	HttpRequest reqVariable = new HttpRequest();
        	reqVariable.setEndpoint(Endpoint);
            reqVariable.setMethod(Method);
            reqVariable.setheader('Content-Type','application/raw');	
            reqVariable.setHeader('Authorization', 'Token ' + Token);
        	reqVariable.setBody(Body);
            //system.debug('Req body :' +reqVariable);
        	//system.debug('Req body :' +Body);
            
            Http httpVariable = new Http();
            HttpResponse resVariableList = httpVariable.send(reqVariable);

            String strjson = '{"Contacts":' + (String)resVariableList.getBody() + '}';
        
            system.debug('Req body Contacts:' +strjson);
        
        	return resVariableList;
    }
    
     public static HttpResponse HttpRequestPOSTMethod_Static(String Endpoint, String Method, String Body)
    {
        	String Token;
            FieldAwareServer__c fs = FieldAwareServer__c.getInstance(userinfo.getProfileId());
            Token = fs.Token__c;
        
        system.debug('Token :'+Token);
         	HttpRequest reqVariable = new HttpRequest();
        	reqVariable.setEndpoint(Endpoint);
            reqVariable.setMethod(Method);
            reqVariable.setheader('Content-Type','application/raw');	
            reqVariable.setHeader('Authorization', 'Token ' + Token);
        	reqVariable.setBody(Body);
            //system.debug('Req body :' +reqVariable);
        	//system.debug('Req body :' +Body);
            
            Http httpVariable = new Http();
            HttpResponse resVariableList = httpVariable.send(reqVariable);

            String strjson = '{"Contacts":' + (String)resVariableList.getBody() + '}';
        
            system.debug('Req body Contacts:' +strjson);
        
        	return resVariableList;
    }
}