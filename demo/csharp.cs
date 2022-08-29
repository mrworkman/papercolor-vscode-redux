using System;

namespace SomeNamespace {

   public enum X {

   }

}


public class SomeClass {
   
   private int _someint = 22;
   private const double x = 0.0;
   private readonly object o = new Object();
   
   private bool x = true;
   private bool x = false;

   // Some Comment...

   /// <summary>Some method.</summary>
   /// <param name="fl">Some description.</param>
   public SomeClass(float fl) {
      int l = 55;
      string x = $"Some {abc} String";
      foo();
   }

   public static void foo() {
      var q = (a) => {
         var verbatim = @"verbatim";
      };

      try {
         // Something...
         if (1 == 1) {
            return;
         } else {
            throw new Exception("Some Exception");
         }
      } catch (Exception e) {
         Debug.WriteLine($"Something happened {e.Message}!"); 
      } finally {
         Debug.WriteLine("Done, and stuff."); 
      }
   }

   [SomeAnnotation(Something = "Something")]
   public string Something { get; set; }

}
