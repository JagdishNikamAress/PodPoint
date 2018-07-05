public class JSONJobList{
	public Integer count;	//2
	public Integer pageSize;	//100
	public cls_items[] items;
	public Integer page;	//0
	class cls_items {		
		public String uuid;	//6142e1f9559940328d380b22ad0db5d3
		public cls_invoice invoice;
		public String completedOn;
		public cls_jobLead jobLead;
		public String scheduledOn;	//2016-04-30T17:33:43+00:00
		public String createdOn;	//2016-04-30T10:33:53+00:00
		public cls_location location;
		public String jobId;	//J115
	}


	class cls_invoice {
	}

	class cls_jobLead {
	}
	class cls_location {
		public String uuid;	//ad0dbe9b222a4616a68c7c4968b51d79
	}
	
	public static JSONJobList parse(String json){
		return (JSONJobList) System.JSON.deserialize(json, JSONJobList.class);
	}

	//static testMethod void testParse() {
	//	String json=		'{"count": 2, "pageSize": 100, "items": [{"startedOn": null, "state": ["scheduled"], "uuid": "6142e1f9559940328d380b22ad0db5d3", "invoice": null, "completedOn": null, "jobLead": null, "scheduledOn": "2016-04-30T17:33:43+00:00", "createdOn": "2016-04-30T10:33:53+00:00", "location": {"uuid": "ad0dbe9b222a4616a68c7c4968b51d79"}, "jobId": "J115"}, {"startedOn": "2016-04-30T17:18:30+00:00", "state": ["active"], "uuid": "35db5821e88b4d3a809ca5ac69c9eb25", "invoice": null, "completedOn": null, "jobLead": {"uuid": "3b14be67d8854df4916c39982e065fbc"}, "scheduledOn": "2016-04-30T17:15:32+00:00", "createdOn": "2016-04-30T10:15:50+00:00", "location": {"uuid": "ad0dbe9b222a4616a68c7c4968b51d79"}, "jobId": "J114"}], "sortedBy": ["-scheduledOn"], "page": 0}'+
	//	'';
	//	JSONJobList obj = parse(json);
	//	System.assert(obj != null);
	//}
}