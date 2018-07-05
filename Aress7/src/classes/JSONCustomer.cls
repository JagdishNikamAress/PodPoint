public class JSONCustomer{
	public Integer count;	//10
	public Integer pageSize;	//20
	public cls_items[] items;
	public cls_sortedBy[] sortedBy;
	public Integer page;	//0
	class cls_items {
		public cls_link link;
		public String uuid;	//c2efdd6051b94deebb75f46a7151909b
		public String name;	//Api3 Latency Ben Speakman
		public Integer customerId;	//51
	}
	class cls_link {
		public String url;	//https://api.fieldaware.net/customer/c2efdd6051b94deebb75f46a7151909b
		public String rel;	//detail	
	}
	class cls_sortedBy {
	}
	public static JSONCustomer parse(String json){
		return (JSONCustomer) System.JSON.deserialize(json, JSONCustomer.class);
	}

	//static testMethod void testParse() {
	//	String json=		'{"count": 10, "pageSize": 20, "items": [{"link": {"url": "https://api.fieldaware.net/customer/c2efdd6051b94deebb75f46a7151909b", "rel": "detail"}, "uuid": "c2efdd6051b94deebb75f46a7151909b", "name": "Api3 Latency Ben Speakman", "customerId": 51}, {"link": {"url": "https://api.fieldaware.net/customer/b6ba4e3cbb94480d8b5c61b47ac07085", "rel": "detail"}, "uuid": "b6ba4e3cbb94480d8b5c61b47ac07085", "name": "Api3 Latency Ben Speakman", "customerId": 52}, {"link": {"url": "https://api.fieldaware.net/customer/33034127d0c04ae5ae87c620d856522a", "rel": "detail"}, "uuid": "33034127d0c04ae5ae87c620d856522a", "name": "Api3 Latency Ben Speakman", "customerId": 53}, {"link": {"url": "https://api.fieldaware.net/customer/39414e66345d4a28b559e645fc867ac7", "rel": "detail"}, "uuid": "39414e66345d4a28b559e645fc867ac7", "name": "Api3 Latency Ben Speakman", "customerId": 54}, {"link": {"url": "https://api.fieldaware.net/customer/e79f3b4e3f2d46d3899003b5f0779db4", "rel": "detail"}, "uuid": "e79f3b4e3f2d46d3899003b5f0779db4", "name": "Api3 Latency Ben Speakman", "customerId": 55}, {"link": {"url": "https://api.fieldaware.net/customer/03c688d5fd6747928a4f2eaf757de181", "rel": "detail"}, "uuid": "03c688d5fd6747928a4f2eaf757de181", "name": "Api3 Latency Ben Speakman", "customerId": 63}, {"link": {"url": "https://api.fieldaware.net/customer/a7d5c828810047bc92acddd4ca29d6ac", "rel": "detail"}, "uuid": "a7d5c828810047bc92acddd4ca29d6ac", "name": "Api3 Latency Ben Speakman", "customerId": 64}, {"link": {"url": "https://api.fieldaware.net/customer/5ce13ba9a8d5460f8632f18e019ebc61", "rel": "detail"}, "uuid": "5ce13ba9a8d5460f8632f18e019ebc61", "name": "Api3 Latency Ben Speakman", "customerId": 65}, {"link": {"url": "https://api.fieldaware.net/customer/fa87d7ab9d494c1cb447c60bdd4df744", "rel": "detail"}, "uuid": "fa87d7ab9d494c1cb447c60bdd4df744", "name": "Api3 Latency Ben Speakman", "customerId": 66}, {"link": {"url": "https://api.fieldaware.net/customer/d36ce4b89bdd45109e540e3a06cb0190", "rel": "detail"}, "uuid": "d36ce4b89bdd45109e540e3a06cb0190", "name": "Api3 Latency Ben Speakman", "customerId": 67}], "sortedBy": [], "page": 0}';
	//	fromJSON obj = parse(json);
	//	System.assert(obj != null);
	//}
}