public class SomeClass {
   
   private int _someint = 22;
   private const double x = 0.0;
   private readonly object o = new Object();
   
   // Some Comment...

   public SomeClass(float fl) {
      int l = 55;
      string x = "Some String";
      foo();
   }

   public static void foo() {
      var q = (a) => {
         var verbatim = @"verbatim";
      };

      // TODO: Something...
      if (1 == 1) {
         return;
      } else {
         throw new Exception("Some Exception");
      }
   }

   [SomeAnnotation(Something = "Something")]
   public string Something { get; set; }

}
