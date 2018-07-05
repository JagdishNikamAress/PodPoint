@istest
public class JSONJobDetails_Test {
static testMethod void testParse() {
		String json=		'{'+
		'    "startedOn": "2016-09-26T16:26:02+00:00",'+
		'    "tasks": ['+
		'        {'+
		'            "note": "",'+
		'            "task": {'+
		'                "description": "",'+
		'                "uuid": "02d68841749048f88b166b6bacd37fa2",'+
		'                "name": "ENA form"'+
		'            },'+
		'            "done": false,'+
		'            "uuid": "24e345cda5684cbda22a67d87228d63f",'+
		'            "attachments": ['+
		'                {'+
		'                    "mimetype": "application/pdf",'+
		'                    "caption": "",'+
		'                    "createdDate": "2016-12-22T11:03:52+00:00",'+
		'                    "uuid": "eec72be68c944931bc70c9041579a581",'+
		'                    "name": "DirectTaxReport.pdf"'+
		'                }'+
		'            ],'+
		'            "items": [],'+
		'            "unitPrice": 0,'+
		'            "unitCost": 0,'+
		'            "asset": null'+
		'        }'+
		'    ],'+
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
		'            "state": "active",'+
		'            "uuid": "3b14be67d8854df4916c39982e065fbc"'+
		'        }'+
		'    ],'+
		'    "state": ['+
		'        "active"'+
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
		'}';
		JSONJobDetails obj = JSONJobDetails.parse(json);
		System.assert(obj != null);
	}
}