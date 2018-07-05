public class sample{
    public ResourceAbsence abs {get; set;}     
    public String Type {get;set;}
    public String slotOption {get;set;}
    public String Duration {get;set;}
    public Date stDt{get;set;}
    public Date StartDate {get;set;}
    public Date EndDate {get;set;}
    
    Id RaRecordTypeId1 = Schema.SObjectType.ResourceAbsence.getRecordTypeInfosByName().get('Non Availability').getRecordTypeId();
    public sample(ApexPages.StandardController controller) {
        abs = new ResourceAbsence (RecordTypeId = RaRecordTypeId1);//,Start=Date.Today(),End=Date.Today());
    }
    
    public List<SelectOption> getTypes(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('None','--- None ---'));        
        options.add(new SelectOption('Extra Shift Opt Out','Extra Shift Opt Out'));
        //options.add(new SelectOption('Meeting','Meeting'));
        //options.add(new SelectOption('Training','Training'));
        options.add(new SelectOption('Medical','Medical'));
        options.add(new SelectOption('Parental','Parental'));
        options.add(new SelectOption('Holiday','Holiday'));
        
        return options;
    } 
    
    public List<SelectOption> getDurations(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('None','--- None ---'));        
        options.add(new SelectOption('Partial Day','Partial Day'));
        options.add(new SelectOption('One Day','One Day'));
        options.add(new SelectOption('Longer','Longer'));
        
        return options;
    }
    
    public List<SelectOption> getSlotOptions(){
        System.debug('StartDate: ' + StartDate);  
        String dayOfWeek;
        if(StartDate!=NULL){
            Date dat = Date.valueOf(StartDate);
            Datetime dt = DateTime.newInstance(dat, Time.newInstance(0, 0, 0, 0));
            dayOfWeek=dt.format('EEEE');
            System.debug('Day : ' + dayOfWeek);
            //StartTime = dayOfWeek;
        }
        
        List<SelectOption> options = new List<SelectOption>();
        
        if(Type == 'Extra Shift Opt Out'){
            system.debug('inside shift ot');
            options.clear();         
            options.add(new SelectOption('Evening (5pm - 8pm)', 'Evening (5pm - 8pm)'));
            options.add(new SelectOption('Full Day (7am - 8pm)', 'Full Day (7am - 8pm)'));
        }
        if(Type == 'Extra Shift Opt Out' && (dayOfWeek=='Saturday' || dayOfWeek=='Sunday')){  
            options.clear();   
            options.add(new SelectOption('Morning (7am -12pm)', 'Morning (7am -12pm)'));
            options.add(new SelectOption('Afternoon (12pm - 8pm)', 'Afternoon (12pm - 8pm)'));
        }else if(Type == 'Extra Shift Opt Out' && (dayOfWeek!='Saturday' || dayOfWeek!='Sunday')){  
            options.clear();   
            options.add(new SelectOption('Evening (5pm - 8pm)', 'Evening (5pm - 8pm)'));
        }else if(Type != 'Extra Shift Opt Out' ){  
            options.clear();   
            options.add(new SelectOption('Morning (7am -12pm)', 'Morning (7am -12pm)'));
            options.add(new SelectOption('Afternoon (12pm - 8pm)', 'Afternoon (12pm - 8pm)'));
            options.add(new SelectOption('Evening (5pm - 8pm)', 'Evening (5pm - 8pm)'));
            options.add(new SelectOption('Full Day (7am - 8pm)', 'Full Day (7am - 8pm)'));
        }else{
            options.add(new SelectOption('None','--- None ---'));
        }
        
        System.debug('Type == ' + Type + ' == Holiday &&' + 'Duration == ' + Duration + ' == ' + 'Partial Day');
        
        if((Type =='Holiday' && Duration=='Partial Day') || (Type =='Parental' && Duration=='Partial Day') || (Type =='Medical' && Duration=='Partial Day')){    
            system.debug('in if condition of holiday=>');
            options.clear();   
            options.add(new SelectOption('Morning (7am -12pm)', 'Morning (7am -12pm)'));
            options.add(new SelectOption('Afternoon (12pm - 8pm)', 'Afternoon (12pm - 8pm)'));
        }else if((Type == 'Holiday' && Duration=='One Day') || (Type == 'Parental' && Duration=='One Day') || (Type == 'Medical' && Duration=='One Day')){    
            options.clear();   
            options.add(new SelectOption('Full Day (7am - 8pm)', 'Full Day (7am - 8pm)'));
        }else if((Type == 'Holiday' && Duration=='Longer') || (Type == 'Parental' && Duration=='Longer') || (Type == 'Medical' && Duration=='Longer')){    
            options.clear();   
            options.add(new SelectOption('Full Day (7am - 8pm)', 'Full Day (7am - 8pm)'));
        }
        return options;
    }
    
    public PageReference customSave(){
        Id parentId = ApexPages.currentPage().getParameters().get('id');
        system.debug('The value of the id===>'+parentId);
        abs.Type = Type;
        abs.Duration__c = Duration;
        Datetime dt = datetime.newInstance(StartDate.year(), StartDate.month(),StartDate.day());
        abs.Start =dt;
        abs.Slot_Options__c = slotOption;
        Datetime dt2;
        if(EndDate!=null){
            dt2 = datetime.newInstance(EndDate.year(), EndDate.month(),EndDate.day());
            abs.End =dt2;
        }
        if(Type=='Extra Shift Opt Out'){
            abs.Duration__c = 'Partial Day';
            if(slotOption=='Morning (7am -12pm)'){
                abs.Start=dt.addHours(7);
                abs.End=dt.addHours(12);
            }else if(slotOption=='Evening (5pm - 8pm)'){
                abs.Start=dt.addHours(17);
                abs.End=dt.addHours(20);
            }
            else if(slotOption=='Afternoon (12pm - 8pm)'){
                abs.Start=dt.addHours(12);
                abs.End=dt.addHours(20);
            }
        }
        if(Type=='Holiday' || Type=='Parental' || Type=='Medical' || Type=='Training' || Type=='Meeting'){
            if(Duration=='Partial Day'){
                if(slotOption=='Morning (7am -12pm)'){
                    abs.Start=dt.addHours(7);
                    abs.End=dt.addHours(12);
                }else if(slotOption=='Afternoon (12pm - 8pm)'){
                    abs.Start=dt.addHours(12);
                    abs.End=dt.addHours(20);
                }else if(slotOption=='Evening (5pm - 8pm)'){
                    abs.Start=dt.addHours(15);
                    abs.End=dt.addHours(20);
                }
            }else  if(Duration=='One Day'){
                abs.Start=dt.addHours(7);
                abs.End=dt.addHours(20);
            }else  if(Duration=='Longer'){
                abs.Start=dt.addHours(7);
                abs.End=dt2.addHours(20);
            }
        }
        abs.ResourceId = parentId;
        System.debug('abs====>'+abs);
        insert abs ;
        
        PageReference pageRef = new PageReference('/apex/AbsenceRelatedList?id=' + parentId );
        pageRef.setRedirect(true);
        return pageRef;
    }
}