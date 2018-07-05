public Class AvoidRecursion{
    public static boolean caseBeforeUpdate = True;
    public static boolean caseBeforeInsert = True;
    
    public static boolean caseAfterUpdate = True;
    public static boolean caseAfterInsert = True;
    
    public static boolean caseBeforeDelete = True;
    public static boolean caseAfterDelete = True;
    
    public static boolean WoBeforeUpdate = True;
    public static boolean WoBeforeInsert = True;
    
    public static boolean WoAfterUpdate = True;
    public static boolean WoAfterInsert = True;
    
    public static boolean saBeforeUpdate = True;
    public static boolean saBeforeInsert = True;
    
    public static boolean saAfterUpdate = True;
    public static boolean saAfterInsert = True;
    
    public static boolean saBeforeDelete = True;
    public static boolean saAfterDelete = True;
    
        public static boolean WoAfterUpdate1 = True;
    public static boolean WoAfterInsert1 = True;
    
    private static boolean firstRun = true;
    public static boolean isFirstRun(){
        if(firstRun){
            firstRun = false;
            return true;
        }else{
            return firstRun;
        }
    }
    
    private static boolean firstRun1 = true;
    public static boolean isFirstRun1(){
        if(firstRun1){
            firstRun1 = false;
            return true;
        }else{
            return firstRun1;
        }
    }
    
        private static boolean firstRun2 = true;
    public static boolean isFirstRun2(){
        if(firstRun2){
            firstRun2 = false;
            return true;
        }else{
            return firstRun2;
        }
    }
    
    private static boolean firstRun3 = true;
    public static boolean isFirstRun3(){
        if(firstRun3){
            firstRun3 = false;
            return true;
        }else{
            return firstRun3;
        }
    }
    
    
        private static boolean firstRun4 = true;
    public static boolean isFirstRun4(){
        if(firstRun4){
            firstRun4 = false;
            return true;
        }else{
            return firstRun4;
        }
    }
    
  private static integer counter=0;
        public static boolean runTwiceCheck(){
        if(counter == 3){
            return false;
        }else{
            counter++;
            return true;
        }
    }
    
      private static integer counter1=0;
        public static boolean saBeforeUpdater(){
        if(counter1 == 2){
            return false;
        }else{
            counter1++;
            return true;
        }
    }
    
     private static integer counter2=0;
        public static boolean saBeforeUpdater1(){
        if(counter2 == 1){
            return false;
        }else{
            counter2++;
            return true;
        }
    }
    
         private static integer counter3=0;
        public static boolean saAfterUpdater(){
        if(counter3 == 2){
            return false;
        }else{
            counter3++;
            return true;
        }
    }
    
    
             private static integer counter4=0;
        public static boolean saAfterUpdater1(){
        if(counter4 == 1){
            return false;
        }else{
            counter4++;
            return true;
        }
    }
    
        
             private static integer counter5=0;
        public static boolean saBeforeDeleter(){
        if(counter5 == 3){
            return false;
        }else{
            counter5++;
            return true;
        }
    }
    
    
     private static integer counter6=0;
        public static boolean caseBeforeUpdater(){
        if(counter6 == 2){
            return false;
        }else{
            counter6++;
            return true;
        }
    }
    
    private static integer counter7=0;
        public static boolean OpptyBeforeInsert(){
        if(counter7 == 1){
            return false;
        }else{
            counter7++;
            return true;
        }
    }
    
    private static integer counter8=0;
        public static boolean OpptyAfterUpdate(){
        if(counter8 == 1){
            return false;
        }else{
            counter8++;
            return true;
        }
    }
    
    private static integer counter9=0;
        public static boolean quoteBeforeInsert(){
        if(counter9 == 1){
            return false;
        }else{
            counter9++;
            return true;
        }
    }
    
    private static integer counter10=0;
        public static boolean quoteBeforeUpdate(){
        if(counter10 == 1){
            return false;
        }else{
            counter10++;
            return true;
        }
    }
    
    private static integer counter11=0;
        public static boolean quoteAfterUpdate(){
        if(counter11 == 1){
            return false;
        }else{
            counter11++;
            return true;
        }
    }
    
    private static integer counter12=0;
        public static boolean accountBeforeInsert(){
        if(counter12 == 1){
            return false;
        }else{
            counter12++;
            return true;
        }
    }
    
    private static integer counter13=0;
        public static boolean accountAfterUpdate(){
        if(counter13 == 1){
            return false;
        }else{
            counter13++;
            return true;
        }
    }
    
    private static integer counter14=0;
        public static boolean feedAfterUpdate(){
        if(counter14 == 1){
            return false;
        }else{
            counter14++;
            return true;
        }
    }
    
    private static integer counter15=0;
        public static boolean feedAfterInsert(){
        if(counter15 == 1){
            return false;
        }else{
            counter15++;
            return true;
        }
    }
    
    private static integer counter16=0;
        public static boolean feedAfterDelete(){
        if(counter16 == 1){
            return false;
        }else{
            counter16++;
            return true;
        }
    }
    
    private static integer counter17=0;
        public static boolean opptyProdAfterInsert(){
        if(counter17 == 3){
            return false;
        }else{
            counter17++;
            return true;
        }
    }
    
    private static integer counter18=0;
        public static boolean opptyProdAfterUpdate(){
        if(counter18 == 1){
            return false;
        }else{
            counter18++;
            return true;
        }
    }
    
    private static integer counter19=0;
        public static boolean opptyProdBeforeDelete(){
        if(counter19 == 1){
            return false;
        }else{
            counter19++;
            return true;
        }
    }
    
    private static integer counter20=0;
        public static boolean opptyProdBeforeUpdate(){
        if(counter20 == 1){
            return false;
        }else{
            counter20++;
            return true;
        }
    }
    
    private static integer counter21=0;
        public static boolean opptyProdBeforeInsert(){
        if(counter21 == 1){
            return false;
        }else{
            counter21++;
            return true;
        }
    }
    
    private static integer counter22=0;
        public static boolean opptyProdAfterDelete(){
        if(counter22 == 1){
            return false;
        }else{
            counter22++;
            return true;
        }
    }
    
     private static integer counter23=0;
        public static boolean OpptyBeforeUpdate(){
        if(counter23 == 3){
            return false;
        }else{
            counter23++;
            return true;
        }
    }
    
    private static integer counter24=0;
        public static boolean qtlAfterInsert(){
        if(counter24 == 2){
            return false;
        }else{
            counter24++;
            return true;
        }
    }
    
    private static integer counter25=0;
        public static boolean qtlAfterUpdate(){
        if(counter25 == 2){
            return false;
        }else{
            counter25++;
            return true;
        }
    }

    private static integer counter26=0;
        public static boolean SATriggerWorkType(){
        if(counter26 == 1){
            return false;
        }else{
            counter26++;
            return true;
        }
    }

     private static integer counter27=0;
        public static boolean WOTriggerWorkType(){
        if(counter27 == 1){
            return false;
        }else{
            counter27++;
            return true;
        }
    }
    
    private static integer counter28=0;
        public static boolean prodRequireAfterInsert(){
        if(counter28 == 2){
            return false;
        }else{ 
            counter28++;
            return true;
        }
    }
    
    private static integer counter29=0;
        public static boolean prodRequireAfterDelete(){
        if(counter29 == 1){
            return false;
        }else{
            counter29++;
            return true;
        }
    }

    private static integer counter30=0;
        public static boolean WoBeforeUpdater(){
        if(counter30 == 3){
            return false;
        }else{
            counter30++;
            return true;
        }
    }
    
      private static integer counter31=0;
        public static boolean WoTypeUpdater(){
        if(counter31 == 1){
            return false;
        }else{
            counter31++;
            return true;
        }
    }
    
          private static integer counter32=0;
        public static boolean saBeforeInserter(){
        if(counter32 == 1){
            return false;
        }else{
            counter32++;
            return true;
        }
    }
    
             private static integer counter33=0;
        public static boolean saBeforeDeleter1(){
        if(counter33 == 1){
            return false;
        }else{
            counter33++;
            return true;
        }
    }
    
          private static integer counter34=0;
        public static boolean saAfterInserter(){
        if(counter34 == 1){
            return false;
        }else{
            counter34++;
            return true;
        }
    }
}