public class GDriveForSalesforceCtrl {
    
    public static String accessToken {
        get {
            Google_Settings__c settings = Google_Settings__c.getValues((ID)'00e24000000znou');
            Auth.JWT jwt = new Auth.JWT();
            jwt.setAud( settings.Token_Endpoint__c );
            jwt.setIss( settings.Service_Account_Id__c );
            jwt.setAdditionalClaims( new Map<String, Object>{ 'scope' => settings.Scopes__c } );
            Auth.JWS jws = new Auth.JWS( jwt, 'privatekey' );
            if(!test.isRunningTest()){
              Auth.JWTBearerTokenExchange bearer = new Auth.JWTBearerTokenExchange(settings.Token_Endpoint__c, jws );
              return bearer.getAccessToken();
            }
           return 'test';
            
        }
    }
}