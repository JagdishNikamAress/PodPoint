public class JSONCustomerResponse{
	public cls_Contacts Contacts;
	class cls_Contacts {
		public cls_website website;
		public cls_fax fax;
		public cls_discount discount;
		public cls_billingLocation billingLocation;
		public cls_link link;
		public boolean taxable;
		public cls_customFields customFields;
		public String uuid;	//a6a6d9abd41a46cd91b505f5048945d0
		public cls_account account;
		public cls_glAccount glAccount;
		public String name;	//Api3 Latency Ben Speakman
		public cls_phone phone;
		public cls_notes notes;
		public cls_email email;
		public cls_location location;
		public boolean onHold;
		public Integer customerId;	//163
	}
	class cls_website {
	}
	class cls_fax {
	}
	class cls_discount {
	}
	class cls_billingLocation {
	}
	class cls_link {
		public String url;	//https://api.fieldaware.net/location/1653f44183004f2a86aa15fa92ae27d4
		public String rel;	//detail
	}
	class cls_customFields {
	}
	class cls_account {
	}
	class cls_glAccount {
	}
	class cls_phone {
	}
	class cls_notes {
	}
	class cls_email {
	}
	class cls_location {
		public boolean isBilling;
		public cls_customer customer;
		public String name;	//Head
		public String locality;	//Ecublens
		public String country;	//Switzerland
		public cls_region region;
		public cls_links[] links;
		public String postcode;	//1024
		public cls_lat lat;
		public cls_link link;
		public cls_lng lng;
		public cls_type type;
		public cls_customFields customFields;
		public String streetName;	//Avenue du Tir Federal 80
		public String uuid;	//1653f44183004f2a86aa15fa92ae27d4
	}
	class cls_customer {
		public String uuid;	//a6a6d9abd41a46cd91b505f5048945d0
	}
	class cls_region {
	}
	class cls_links {
		public String url;	//https://api.fieldaware.net/customer/a6a6d9abd41a46cd91b505f5048945d0
		public String rel;	//customer
	}
	class cls_lat {
	}
	class cls_lng {
	}
	class cls_type {
	}
	public static JSONCustomerResponse parse(String json){
		return (JSONCustomerResponse) System.JSON.deserialize(json, JSONCustomerResponse.class);
	}

	//static testMethod void testParse() {
	//	String json=		'{"Contacts":{"website": null, "fax": null, "discount": null, "billingLocation": null, "link": {"url": "https://api.fieldaware.net/customer/a6a6d9abd41a46cd91b505f5048945d0", "rel": "detail"}, "taxable": true, "customFields": {}, "uuid": "a6a6d9abd41a46cd91b505f5048945d0", "account": null, "glAccount": null, "name": "Api3 Latency Ben Speakman", "phone": null, "notes": null, "email": null, "location": {"isBilling": false, "customer": {"uuid": "a6a6d9abd41a46cd91b505f5048945d0"}, "name": "Head", "locality": "Ecublens", "country": "Switzerland", "region": null, "_links": [{"url": "https://api.fieldaware.net/customer/a6a6d9abd41a46cd91b505f5048945d0", "rel": "customer"}, {"url": "https://api.fieldaware.net/location/1653f44183004f2a86aa15fa92ae27d4", "rel": "self"}], "postcode": "1024", "lat": null, "link": {"url": "https://api.fieldaware.net/location/1653f44183004f2a86aa15fa92ae27d4", "rel": "detail"}, "lng": null, "type": null, "customFields": {}, "streetName": "Avenue du Tir Federal 80", "uuid": "1653f44183004f2a86aa15fa92ae27d4"}, "onHold": false, "customerId": 163}}';
	//	JSONCustomerResponse obj = parse(json);
	//	System.assert(obj != null);
	//}
}