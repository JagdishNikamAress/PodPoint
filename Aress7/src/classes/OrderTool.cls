public class OrderTool {
    
   /* private static final String token = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjI1ZjExOWJmZDE1ODMxN2ZjOWQzODJiYjZhM2NkMDllOTFlZmY4NjZmMWJiNGZhMjQ2NmU2YjRlMTM1MGExNGNkY2RjM2ZiNjUxZjFhYzllIn0.eyJhdWQiOiI2IiwianRpIjoiMjVmMTE5YmZkMTU4MzE3ZmM5ZDM4MmJiNmEzY2QwOWU5MWVmZjg2NmYxYmI0ZmEyNDY2ZTZiNGUxMzUwYTE0Y2RjZGMzZmI2NTFmMWFjOWUiLCJpYXQiOjE1MjgyMDIxODEsIm5iZiI6MTUyODIwMjE4MSwiZXhwIjoxNTU5NzM4MTgxLCJzdWIiOiI0MjAiLCJzY29wZXMiOltdfQ.ogWObZZaO_UlcriQZElEQLDXacv6Gqxz0_T1H3fbA-a0eoEkx0_X0_tQY5PTbShyZk0VVmCvC0VTvwxsIUg9r0vQ-Rin1dMOsPWnXIZINHe4z4YFB6LJOfdN8YRLZqZVJ52omHJG9x5IGUdcJqj-KdjsOlUjGKhRmGVrKE29bBt7z5K42cpl5OhZvdNkI80e-ZiafSR4jbvr4hAh4-gOaDoewhpCsXcWaRk6NtZTK9RUtj91pmy8FHFroIuQ4jw3PUbSC06-CABnIUB33tibEVilbI6T2JqUrXZnHgiDDFp_zHUfCKjFv_mbHgIv_xmU2_OrvGHGAUgPj9sw8eoNJh8ZDfXU70Yl4kGdyjwr8P9RkzsCstNWe8tnb_8QGRjQ7zDfjASrOFRDjEOftNaLWQ6DQCIs_aZv1XXWOpdECNU5oPk4MaFQsio8BG6Pbjto0twYgINkMKHWIL3HTSDQyc1kb7IjgAX96LCOxBT8CTGn7JpqiEYE3dOZUz9kE633CMZk-ZC3KBu5Lf3MtLr1e5jbUGzJuxXfyA7T4NQHJO9m6_XufsUOOAvgXRDLn7b68Q0r4LKqm8NtVxniF4O9tiu4i1-nrOLCG0dGWRp2wbXI7QmnSbkuGim20CPl0rOoZ_oAnSfpLJzANPwLNWHOZBPRnkyBs2kFEhFpbLc6B3c';
    private static final String endpoint = 'https://ordering-staging.pod-point.com/api/v1/installations/';*/
    
    private static final String token = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjA2ZGI0NDJiYWM1MWJhOWE2ZjBiNGFkMGNkNzI3MDUyODI4NzgzNjdhZDI5NDFiODA2OWU2Y2Q2ZmE5NGJkYzAxZDViYjg4MmIxZjk0MzZiIn0.eyJhdWQiOiI2IiwianRpIjoiMDZkYjQ0MmJhYzUxYmE5YTZmMGI0YWQwY2Q3MjcwNTI4Mjg3ODM2N2FkMjk0MWI4MDY5ZTZjZDZmYTk0YmRjMDFkNWJiODgyYjFmOTQzNmIiLCJpYXQiOjE1MTg0NDY0NzQsIm5iZiI6MTUxODQ0NjQ3NCwiZXhwIjoxNTQ5OTgyNDc0LCJzdWIiOiI3MDQiLCJzY29wZXMiOltdfQ.SCZfXzBfHDKQtTvRgy9QuEXipQ3mwgzp0jtGKtpJKZcVe9V2A8E0wG5kVcfY7O-3Q8T2-gfGTRgPWPvnfKyQCXbMLTYRPjHQb_ClcvDBcBHPp7DydU28saDCyfeicqgkUZhWOQ_gESuwIVemmDDU3LirORZV6kzyjVcpueOsZ4k1-xI-jfKCzE9NKEmReEQLN6AdO4jo-OY8Bmzx1BdW16YkbpaZovig2_mzMIKqaPwIiLIM0K6Sj-PWxci4k4_CNnIUhmHleePJCYTaD5s6G09blx-hu7o8eh3QRLPkW3XQ27QQvYSogtzyDm06BZXu2TAHapakqHpWVPWImALSMINHxHIl9MhI_7QiF9sW8HKHEC71VcYMS4FeUOk8LRwbw5Vxuto7M44tLDgifuCqcZJ-5Rce8eZGRfQZj9nruPKy5HVsEwlM5GpNE1gdcrIMaf8O-rHZCjdb4bn83xjh7yNBZbyikeiVnEu9cax0gSxVdQxzMR--ffijDX1kRnb0UlpLXfm-yAGu3sYVybZwxWDOTf4YWOJFSFSHPtQs-yjgVt3qfgyvTTqd56lIgdQz_Fxf5F2zhbnlPApDq4AKla4nGqog-IITvO1Dsa3KI4mL5P7cCtdL1X9nKXYl2FtwTuB547AupB0CFPuG7qxmo_5a9CcKDYskW8oP_-TPZUM';
    private static final String endpoint = 'https://ordering.pod-point.com/api/v1/installations/';
    //When workOrder is scheduled this method getting call from workOrder trigger
    @future(callout=true)
    public static void pushDataScheduled(String id, string status, DateTime scheduledAt, string UUID) {
        ScheduledData scheduledData = new ScheduledData();
        scheduledData.status = status.toLowerCase();
        scheduledData.scheduledAt = scheduledAt.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'');
        
        Data data = new Data();
        data.fieldServiceInstall = scheduledData;
        
        OrderTool.makeRequest(UUID, data);
    }
    
    //When WorkOrder is InComplete / Rejected / Paused / On Hold
    @future(callout=true)
    public static void pushData2(String id, string status, string UUID) {
        StatusData statusData = new StatusData();
        statusData.status = status.toLowerCase();
        
        Data data = new Data();
        data.fieldServiceInstall = statusData;
        
        OrderTool.makeRequest(UUID, data);
    }
    
    //When WorkOrder is Complete
    @future(callout=true)
    public static void pushData3(String id, string status, string UUID, String serialNumber, DateTime adminCompletedAt, String customerName, String customerRelationship, String installerName, String installerEmail, String installerId, Decimal maximumDemandAmps, Decimal propertyServiceCutOutRatingAmps, Decimal chargePointRatingAmps, String earthingArrangements, String vrn, DateTime customerSignedAt) {
        Customer customer = new Customer();
        customer.name = customerName;
        customer.relationship = customerRelationship;
        
        ProviderData providerData = new ProviderData();
        providerData.id = id;
        providerData.maximumDemandAmps = maximumDemandAmps;
        providerData.propertyServiceCutOutRatingAmps = propertyServiceCutOutRatingAmps;
        providerData.chargePointRatingAmps = chargePointRatingAmps;
        providerData.earthingArrangements = earthingArrangements;
        providerData.vrn = vrn;
        providerData.customer = Customer;
        
        Provider provider = new Provider();
        provider.fieldServiceLightning = providerData;
        
        Installer installer = new Installer();
        installer.email = installerEmail;
        installer.id = installerId;
        installer.name = installerName;
        
        CompletedData completedData = new CompletedData();
        completedData.status = status.toLowerCase();
        completedData.serialNumber = serialNumber;
        if (test.isRunningTest()) {
             completedData.adminCompletedAt = string.valueOf(system.today());
        } else {
            completedData.adminCompletedAt = adminCompletedAt.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'');
        }
        completedData.installer = Installer;
        completedData.provider = Provider;
        if(test.isRunningTest()){
            completedData.customerSignedAt = string.valueof(system.now());
        }else{
        completedData.customerSignedAt = customerSignedAt.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\'');
        }
        Data data = new Data();
        data.fieldServiceInstall = completedData;
        
        OrderTool.makeRequest(UUID, data);
    }
   
    // Make request to the API
    public static void makeRequest(string UUID, Data data) { 
        JSON2Apex jsonWrapper = new JSON2Apex();
        jsonWrapper.Data = data;
        jsonWrapper.method = 'PATCH';
        
        String uri = OrderTool.endpoint + UUID;
        String jsonBody = JSON.serialize(jsonWrapper);
        
        jsonBody = jsonBody.replace('method', '_method');
        
        system.debug('JSON Body' + jsonBody);
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        
        request.setEndpoint(uri);
        request.setMethod('POST');
        request.setHeader('Content-Type','application/json');
        request.setHeader('Accept','application/json');
        request.setHeader('Authorization', 'Bearer ' + OrderTool.token);
        request.setBody(jsonBody);
        
        HttpResponse response = http.send(request);
        
        String responseData = response.getBody();
        system.debug('Response Body' + responseData);
    }
    
    public class Data {
        public Object fieldServiceInstall;
    }
    
    public class JSON2Apex {
        public String method;
        public Data data;
    }
    
    public class StatusData {
        public String status;
    }
    
    public class ScheduledData {
        public String status;
        public String scheduledAt;
    }
    
    class CompletedData {
        public String status;
        public String serialNumber;
        public String subContractor = 'Pod Point';
        public String adminCompletedAt;
        public String customerSignedAt;
        public Installer installer;
        public Provider provider;
    }
    
    public class Provider {
        public ProviderData fieldServiceLightning;
    }
    
    public class ProviderData {
        public String id;
        public Decimal maximumDemandAmps;
        public Decimal propertyServiceCutOutRatingAmps;
        public Decimal chargePointRatingAmps;
        public String earthingArrangements;
            public String vrn;
        public Customer customer;
    }

    public class Customer {
        public String name;
        public String relationship;
    }

    public class Installer {
        public String id;
        public String name;
        public String email;
    }
}