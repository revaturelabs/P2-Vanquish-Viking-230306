/*Created By: Khalil Newsome
 * Last Updated: 03/21/2023
 * Description: Helper for CustomerStoryTrigger. Assigns Ranks to Success Stories
 */


public class CustomerStoryHelper {
    
    static List<Customer_Success_Story__c> ratedStories = [SELECT Success_Rating__c FROM Customer_Success_Story__c ORDER BY Success_Rating__c DESC];    
    
    public static void RankAssignment(List<Customer_Success_Story__c> storyToRank){
        
        for(Customer_Success_Story__c story: storyToRank){
            if(story.Success_Rating__c<1||story.Success_Rating__c>5){
                story.addError('Please insert a number that is between 1 and 5! You are allowed decimal values.');
            }else{
                ratedStories.add(story);        
            }
        }
        sortList(ratedStories);
        List<Customer_Success_Story__c> listCopy= new List<Customer_Success_Story__c>();
        for(Customer_Success_Story__c story:ratedStories){
            story.Success_Rank__c = ratedStories.indexOf(story)+1;
            if(!Trigger.new.contains(story)){
                listCopy.add(Story);
            }
        }
        System.debug(listCopy);
        System.debug(ratedStories);
        
        Database.update(listCopy,false);
        
        
        
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
    
    public static void updateRank(List<Customer_Success_Story__c> toUpdate,List<Customer_Success_Story__c> ogStories){
        for(Customer_Success_Story__c checkRating:toUpdate){
            if(checkRating.Success_Rating__c<1||checkRating.Success_Rating__c>5){
                checkRating.addError('Please insert a number that is between 1 and 5! You are allowed decimal values.');
            }
        }
        Boolean ratingChanged=false;
        for(Integer i=0;i<toUpdate.size();i++){
            Customer_Success_Story__c updatedStory=toUpdate[i];
            Customer_Success_Story__c ogStory=ogStories[i];
            if(updatedStory.Success_Rating__c!=ogStory.Success_Rating__c){
                ratingChanged=true;
                Break;
            }
        }
        if(!ratingChanged){
            return;
        }
        List<Customer_Success_Story__c>existStory=[SELECT Success_Rating__c FROM Customer_Success_Story__c WHERE Id NOT IN:Trigger.new ORDER BY Success_Rating__c DESC];
        existStory.addAll(toUpdate);
        sortList(existStory);
        List<Customer_Success_Story__c> listCopy = new List<Customer_Success_Story__c>(existStory);
        for(Customer_Success_Story__c story:existStory){
            story.Success_Rank__c = existStory.indexOf(story)+1;
            listCopy[listCopy.indexOf(story)].Success_Rank__c= existStory.indexOf(story)+1;
            if(Trigger.new.contains(story)){
                listCopy.remove(listCopy.indexOf(Story));
            }
        }
        
        Database.update(listCopy,false);
    }
    
    
}