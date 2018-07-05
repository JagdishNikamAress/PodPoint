@isTest
global class MockHttpResponseGenerator implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setStatusCode(200);
        res.setStatus('OK');
        if(req.getEndpoint()== 'https://api.fieldaware.net/job/j001'&& req.getMethod() == 'GET'){
        res.setHeader('Content-Type', 'application/json');
        res.setBody( '{'+
    '    "startedOn": "2016-09-26T16:26:02+00:00",'+
    '    "tasks": [],'+
    '    "description": "This is how we will install.",'+
    '    "revenue": 0,'+
    '    "signature": null,'+
    '    "jobId": "J378",'+
    '    "invoice": null,'+
    '    "jobLead": {'+
    '        "emailAddress": "ben.speakman@pod-point.com",'+
    '        "telno": "5454545544545",'+
    '        "surname": "testerson",'+
    '        "uuid": "3b14be67d8854df4916c39982e065fbc",'+
    '        "name": "tester"'+
    '    },'+
    '    "scheduledOn": "2016-09-26T16:45:00+00:00",'+
    '    "labor": [],'+
    '    "pre_signature": null,'+
    '    "customer": {'+
    '        "uuid": "5fc3139aa76845fc92bcfa63e55e40f1",'+
    '        "name": "Daniel Kaplansky",'+
    '        "customerId": 405'+
    '    },'+
    '    "estDuration": 0,'+
    '    "uuid": "6ee4bdc8edee40aab8102b2344a30bc8",'+
    '    "createdOn": "2016-09-26T15:45:28+00:00",'+
    '    "crew": ['+
    '        {'+
    '            "workedHours": ['+
    '                {'+
    '                    "start": "2016-09-26T16:26:02+00:00",'+
    '                    "inTransit": false,'+
    '                    "end": "2016-09-26T16:26:02+00:00"'+
    '                }'+
    '            ],'+
    '            "state": "completed",'+
    '            "uuid": "3b14be67d8854df4916c39982e065fbc"'+
    '        }'+
    '    ],'+
    '    "state": ['+
    '        "completed"'+
    '    ],'+
    '    "contact": null,'+
    '    "asset": null,'+
    '    "completedOn": "2016-09-26T16:26:02+00:00",'+
    '    "customFields": {'+
    '        "7424ee65493d40d88498771fee88c314": "(Commercial) Solo Install - Manual"'+
    '    },'+
    '    "location": {'+
    '        "uuid": "f6b50a3118c44598ab5d463352c7ff97",'+
    '        "locality": "London",'+
    '        "country": "United Kingdom",'+
    '        "region": null,'+
    '        "postcode": "EC1Y 8QE",'+
    '        "streetName": "This is my address yay!",'+
    '        "name": "Head"'+
    '    }'+
    '}');
        }
        if(req.getEndpoint()=='https://api.fieldaware.net/customer/'&& req.getMethod() == 'GET')
        {
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"Contacts":{"website": null, "fax": null, "discount": null, "billingLocation": null, "link":'+
                        '{"url": "https://api.fieldaware.net/customer/a6a6d9abd41a46cd91b505f5048945d0", "rel": "detail"},'+
                        ' "taxable": true, "customFields": {}, "uuid": "a6a6d9abd41a46cd91b505f5048945d0", "account": null, "glAccount":'+
                        ' null, "name": "Api3 Latency Ben Speakman", "phone": null, "notes": null, "email": null, "location": {"isBilling": '+
                        ' false, "customer": {"uuid": "a6a6d9abd41a46cd91b505f5048945d0"}, "name": "Head", "locality": "Ecublens", "country": '+
                        ' "Switzerland", "region": null, "_links": [{"url": "https://api.fieldaware.net/customer/a6a6d9abd41a46cd91b505f5048945d0",'+
                        ' "rel": "customer"}, {"url": "https://api.fieldaware.net/location/1653f44183004f2a86aa15fa92ae27d4", "rel": "self"}], "postcode":'+
                        ' "1024", "lat": null, "link": {"url": "https://api.fieldaware.net/location/1653f44183004f2a86aa15fa92ae27d4", "rel": "detail"}, "lng":'+
                        ' null, "type": null, "customFields": {}, "streetName": "Avenue du Tir Federal 80", "uuid": "1653f44183004f2a86aa15fa92ae27d4"}, "onHold": '+
                        'false, "customerId": 163}}');      
    }
        if(req.getEndpoint()=='https://api.fieldaware.net/customer/'&& req.getMethod() == 'PUT')
        {
            res.setStatusCode(200);
            res.setStatus('OK');
        }
        if(req.getEndpoint()=='https://api.fieldaware.net/job/'&& req.getMethod() == 'POST')
        {
            res.setStatusCode(201);
            res.setStatus('CREATED');
            res.setBody('{"startedOn": null, "tasks": [{"attachments": [], "done": false, "unitPrice": 0.00000, "task": {"description": "", "uuid": "f43c2ff616c248a99abe8b6d0d22c46b", "name": "Fill in site survey form"}, "uuid": "969848bbc11b4cf1a60a13e4a60594b5", "items": [], "note": "Fill in site survey form", "asset": null, "customFields": {}, "unitCost": 10.00}, {"attachments": [], "done": false, "unitPrice": 0.00000, "task": {"description": "", "uuid": "695bab4bd85a4e079d21fd91935bdd37", "name": "Completed customer signed Annex D"}, "uuid": "2203f91045a6441b8b51230a2da59c26", "items": [], "note": "Completed customer signed Annex D", "asset": null, "customFields": {}, "unitCost": 10.00}, {"attachments": [], "done": false, "unitPrice": 0.00000, "task": {"description": "", "uuid": "c11386b7759a4ba3a5505142a6936788", "name": "offstreet parking photo"}, "uuid": "e2d4ed944ad14faf94cdc9633a2dc667", "items": [], "note": "offstreet parking photo", "asset": null, "customFields": {}, "unitCost": 10.00}, {"attachments": [], "done": false, "unitPrice": 0.00000, "task": {"description": "", "uuid": "f2a544fcf4344da8afe020be8a58bc3a", "name": "Photo of mains supply service head."}, "uuid": "0bd67a7ee2944d2fb6c68c1358e33411", "items": [], "note": "Photo of mains supply service head.", "asset": null, "customFields": {}, "unitCost": 10.00}, {"attachments": [], "done": false, "unitPrice": 0.00000, "task": {"description": "", "uuid": "e0a2de0cbb134f69b3d961c05dac7bce", "name": "Distribution board photo"}, "uuid": "6a7a7f3bf4c4486c830c32996a31b2f0", "items": [], "note": "Distribution board photo", "asset": null, "customFields": {}, "unitCost": 10.00}, {"attachments": [], "done": false, "unitPrice": 0.00000, "task": {"description": "", "uuid": "02d68841749048f88b166b6bacd37fa2", "name": "ENA form"}, "uuid": "e7550a30ba294bd5a07b4958d33e5c9c", "items": [], "note": "ENA form", "asset": null, "customFields": {}, "unitCost": 10.00}, {"attachments": [], "done": false, "unitPrice": 0.00000, "task": {"description": "", "uuid": "d9b7be8d1758495c84f89fbe1cde99f7", "name": "Install Lock"}, "uuid": "3a7e4360b4fb46c09c19ad23a5848eef", "items": [], "note": "Install Lock", "asset": null, "customFields": {}, "unitCost": 10.00}, {"attachments": [], "done": false, "unitPrice": 0.00000, "task": {"description": "", "uuid": "d269a028a00e4a128209e371f606031f", "name": "Photo of serial number"}, "uuid": "65139d54707e4592a4ea0c4959b4fe1a", "items": [], "note": "Photo of serial number", "asset": null, "customFields": {}, "unitCost": 10.00}], "description": "Awaiting description of works.", "revenue": 0, "completedOn": null, "crew": [], "jobId": "J695", "link": {"url": "https://api.fieldaware.net/job/af959aa05d154ee9a615919cf2fd8c7b", "rel": "detail"}, "invoice": null, "jobLead": null, "scheduledOn": "2017-05-27T19:58:08+00:00", "estDuration": null, "uuid": "af959aa05d154ee9a615919cf2fd8c7b", "customer": {"uuid": "840cf13c5aee42308652f144dc3761f7", "name": "First Last", "customerId": 516}, "pre_signature": null, "createdOn": "2017-05-27T18:58:08.401454+00:00", "labor": [], "state": ["scheduled"], "contact": null, "asset": null, "signature": null, "customFields": {"7424ee65493d40d88498771fee88c314": "(Commercial) Solo Install - Manual"}, "location": {"uuid": "7cfeb9e21ea748b0a4fa8e8152e65870", "locality": "city", "country": "United Kingdom", "region": null, "postcode": "234324", "streetName": "street", "name": "First name"}}');
        }
       
        return res;
    }
}