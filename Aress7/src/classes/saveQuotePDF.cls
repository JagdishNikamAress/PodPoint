public class saveQuotePDF{
    
    @future(Callout=true)
    public static void savePDF(string quoteID)
    {
        system.debug('Inside savePDF');
        system.debug('quoteID : ' + quoteID);
        QuoteID = quoteID;
        String quotetemplateID = '0EH24000000yKo7';
        String quoteUrl = '/quote/quoteTemplateDataViewer.apexp?id=';
        quoteUrl +=QuoteID;            
        quoteUrl +='&headerHeight=190&footerHeight=188&summlid=';            
        quoteUrl +=quotetemplateID ;            
        quoteUrl +='#toolbar=1&navpanes=0&zoom=90';
        
        //Create pdf content
        PageReference pg = new PageReference(quoteUrl) ;
        
        //Document object of quote which hold the quote pdf
        QuoteDocument quotedoc = new QuoteDocument(); 
        
        Blob b;
        if (Test.IsRunningTest())
        {
            b = Blob.valueOf('UNIT.TEST');
        }
        else
        {
            b = pg.getContentAsPDF() ;
        }
        
        
        
        //content assign to document
        quotedoc.Document = b;
        
        //assign quote id where pdf should attach
        quotedoc.QuoteId = QuoteID ;
        
        //insert the quotdoc
        if(!Test.IsRunningTest())
        	insert quotedoc; 
        
        system.debug('End of savePDF');
    }

}