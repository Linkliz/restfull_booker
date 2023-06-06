package crud;

import com.intuit.karate.junit5.Karate;

public class CrudRunner {
    @Karate.Test
    Karate filterResponseRunner() {
        return Karate.run("crud_restfull_booker.feature").relativeTo(getClass());
    }
}
