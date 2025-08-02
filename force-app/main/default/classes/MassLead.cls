public class MassLead {
    public static void op (){
    List<Case> casesToUpdate = new List<Case>();
    for(Case thiscase : [Select Id, Status From Case LIMIT 50000]) {
        thiscase.Status = 'Working';
        casesToUpdate.add(thiscase);
    }
    Try{
        Database.update(casesToUpdate, false);
    } catch(Exception e){
        System.debug(e.getMessage());
    }
   
    }
}