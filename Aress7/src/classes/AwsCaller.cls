public class AwsCaller {
	@Future(Callout=True)
    public static void amazonS3caller(SET<String> woIdSet){
    	system.debug('*** amazonS3caller: ' + woIdSet);
        AmazonS3UploaderClass awscaller = new AmazonS3UploaderClass(woIdSet);
    }
    
    @Future(Callout=True)
    public static void sReportAmazonS3caller(SET<String> saIdSet){
    	system.debug('*** sReportAmazonS3caller: ' + saIdSet);
        SAReportUploaderClass awscaller = new SAReportUploaderClass(saIdSet);
    }
}