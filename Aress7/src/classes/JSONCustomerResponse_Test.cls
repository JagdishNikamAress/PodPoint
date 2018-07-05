@isTest
public class JSONCustomerResponse_Test 
{
	static testMethod void testParse() {
		String json=		'{"Contacts":{"website": null, "fax": null, "discount": null, "billingLocation": null, "link": {"url": "https://api.fieldaware.net/customer/a6a6d9abd41a46cd91b505f5048945d0", "rel": "detail"}, "taxable": true, "customFields": {}, "uuid": "a6a6d9abd41a46cd91b505f5048945d0", "account": null, "glAccount": null, "name": "Api3 Latency Ben Speakman", "phone": null, "notes": null, "email": null, "location": {"isBilling": false, "customer": {"uuid": "a6a6d9abd41a46cd91b505f5048945d0"}, "name": "Head", "locality": "Ecublens", "country": "Switzerland", "region": null, "_links": [{"url": "https://api.fieldaware.net/customer/a6a6d9abd41a46cd91b505f5048945d0", "rel": "customer"}, {"url": "https://api.fieldaware.net/location/1653f44183004f2a86aa15fa92ae27d4", "rel": "self"}], "postcode": "1024", "lat": null, "link": {"url": "https://api.fieldaware.net/location/1653f44183004f2a86aa15fa92ae27d4", "rel": "detail"}, "lng": null, "type": null, "customFields": {}, "streetName": "Avenue du Tir Federal 80", "uuid": "1653f44183004f2a86aa15fa92ae27d4"}, "onHold": false, "customerId": 163}}';
		JSONCustomerResponse obj = JSONCustomerResponse.parse(json);
		System.assert(obj != null);
	}
}