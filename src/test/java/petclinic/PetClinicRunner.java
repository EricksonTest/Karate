package petclinic;

import com.intuit.karate.Results;
import com.intuit.karate.Runner;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

class PetClinicRunner {

    @Test
    void runPetClinicCoverage() {
        String requestedTags = System.getProperty("karate.tags");
        int threads = Integer.getInteger("karate.threads", 4);

        Results parallelResults = configuredRunner("target/karate-reports/parallel")
                .tags(requestedTags == null ? "~@known-defect" : requestedTags)
                .tags("~@serial")
                .parallel(threads);

        Results serialResults = configuredRunner("target/karate-reports/serial")
                .tags(requestedTags == null ? "~@known-defect" : requestedTags)
                .tags("@serial")
                .parallel(1);

        int failures = parallelResults.getFailCount() + serialResults.getFailCount();
        String errors = parallelResults.getErrorMessages() + serialResults.getErrorMessages();
        assertEquals(0, failures, errors);
    }

    private Runner.Builder configuredRunner(String reportDir) {
        return Runner.path("classpath:petclinic/features")
                .outputCucumberJson(true)
                .outputJunitXml(true)
                .reportDir(reportDir);
    }
}
