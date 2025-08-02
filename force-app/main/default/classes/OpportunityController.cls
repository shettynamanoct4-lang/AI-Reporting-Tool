public class OpportunityController {
    
    @AuraEnabled(cacheable=true)
    public static List<Opportunity> getOpportunities() {
      return [SELECT Id, Name,StageName ,Probability FROM Opportunity];
    }
    

}