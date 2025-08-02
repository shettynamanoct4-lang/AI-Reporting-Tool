public class UpdateInsertDemo {
    public static void myMethod(){
        List<Product2> pr = [Select Name, ProductCode from Product2];
        for(Product2 pd : pr){
            pd.Name = pd.Name + '04';
        }
        Product2 p1 = new Product2(Name = 'Krishna', ProductCode = '456');
        Product2 p2 = new Product2(Name = 'Vishnu', ProductCode = '46');
        pr.add(p1);
        pr.add(p2);
        upsert pr;
    }

}