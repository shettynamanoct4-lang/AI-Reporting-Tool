public class GeneratePDFController {
    public List<Account> accList{get;set;}
    public String actIndustry{get;set;}
    
    public GeneratePDFController(){
        accList= new List<Account>();
        actIndustry = System.currentPageReference().getParameters().get('Industry');
        System.debug('Industry: ' + actIndustry);
        //String str = '%' + actIndustry + '%';
        //accList= [select id,name,type,industry from Account where industry!=null and industry like :str];
        String str = actIndustry;
        accList= [select id,name,type,industry from Account where industry!=null and industry = :str];
    }
    
}