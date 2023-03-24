public class CustomerStoryHelper {
    public static void RankAssignment(List<Customer_Success_Story__c> storyToRank){
     List<Customer_Success_Story__c> ratedStories = [SELECT Success_Rating__c FROM Customer_Success_Story__c ORDER BY Success_Rating__c DESC];
       for(Customer_Success_Story__c stories:storyToRank){
            ratedStories.add(stories);
        }
        sortList(ratedStories);
    	reassignRank(ratedStories);
   }
    
    public static List<Customer_Success_Story__c> sortList(List<Customer_Success_Story__c> listToSort){
        
        for(Integer i=0;i<listToSort.size()-1;i++){
            for(Integer j=i+1 ; j< listToSort.size();j++){
                Customer_Success_Story__c tempStory;
                if(listToSort[i].Success_Rating__c < listToSort[j].Success_Rating__c){
                     tempStory = listToSort[i];
                    listToSort[i] = listToSort[j];
                    listToSort[j] = tempStory;
                }
            }
        }
        //System.debug(listToSort);
        return listToSort;
    }
    
    public static void reassignRank(List<Customer_Success_Story__c> toReassign){
        List<Customer_Success_Story__c> newlist = new List<Customer_Success_Story__c>();
        for(Customer_Success_Story__c redo: toReassign){
            redo.Success_Rank__c= toReassign.indexOf(redo) + 1;
            if(!Trigger.new.contains(redo)){
                newlist.add(redo);
            }
        }
        Database.update (newlist,false);
    }
    
    public static void UpdateRank(List<Customer_Success_Story__c> toUpdate){
        List<Customer_Success_Story__c> newUpdate = new List<Customer_Success_Story__c>();
        List<Customer_Success_Story__c> storiesRated = [SELECT Id, Success_Rating__c FROM Customer_Success_Story__c ORDER BY Success_Rating__c DESC];
        for(Customer_Success_Story__c newval: toUpdate){
               storiesRated.add(newval);
        }
        sortList(storiesRated);
        for(Customer_Success_Story__c updated: storiesRated){
            updated.Success_Rank__c= storiesRated.indexOf(updated)+1;
        }
        newUpdate=storiesRated;
        
    }
    
    public static void preventChange(List<Customer_Success_Story__c> change){
        for(Customer_Success_Story__c attempt:change){
            if(Trigger.isUpdate){
                attempt.addError('values cannot be updated once set!');
                
            }
        }
    }   
}