public class checkRecursive {
     public static boolean checkk = true;
     public static boolean skip_install_statuscheck_whencasecreated = false;
     public static Map<String,Id> WorkTypeMap = new  Map<String,Id>();
     public static void callworktypemap(){
        list<worktype> WorkTypeList= [SELECT Id, name from WorkType];
        for(WorkType wt: WorkTypeList){
            WorkTypeMap.put(wt.Name, wt.Id);
        }
        checkk = false;
     }
}