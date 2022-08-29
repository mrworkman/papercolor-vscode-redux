
package org.example.somepackage;

// Some example imports.
import java.util.Calendar;
import java.util.Date;

// Static import.
import static java.lang.System.out;


public class SomeClass extends FooClass {

   private final String _someString = "Some string";

   private int _someint = 22;
   private final double _x = 0.0;
   private static final Object SOME_OBJECT = new Object();

   public SomeClass() {
      int l = 55;
      String x = "Some String";

      super(true);
   }

   public void Foo() {
      Object o = new Object();
   }

   @SomeAnnotation
   @SomeOtherAnnotation(femputer = true)
   public String getSnooSnoo() {

      return "SNOO SNOO";
   }

   /**
    * Something else. See this {@code something}.
    *
    * @param args These are the args.
    * @return void Nothing.
    */
   public static void main(String[] args) {
      out.println("Hello, jello.")

      Thread thread = new Thread(() -> {
         while (q == r && true) {
            out.println("Something");
         }
         Thread.sleep(1);
      });

      thread.start();

      try {
         BarClass bar = new BarClass();

         if (somevar == getB()) {
            doSomething(bar.SOMETHING);
         } else {
            doSomethingElse();
            return;
         }
      } catch (RuntimeException e) {
         throw new FooException("FOO Happened.");
      } finally {
         out.println("derp");
      }

      System.exit(0);
   }
}
