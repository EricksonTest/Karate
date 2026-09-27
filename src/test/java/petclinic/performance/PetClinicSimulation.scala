package petclinic.performance

import com.intuit.karate.gatling.PreDef._
import io.gatling.core.Predef._

import scala.concurrent.duration._
import scala.language.postfixOps

class PetClinicSimulation extends Simulation {

  private val users = sys.props.get("gatling.users").map(_.toInt).getOrElse(20)
  private val rampSeconds = sys.props.get("gatling.rampSeconds").map(_.toInt).getOrElse(10)

  private val protocol = karateProtocol(
    "/pettypes" -> Nil,
    "/vets" -> Nil,
    "/v2/owners" -> Nil,
    "/v2/pets" -> Nil,
    "/specialties" -> Nil
  )

  private val referenceData = scenario("petclinic-reference-data")
    .exec(karateFeature("classpath:petclinic/performance/catalog-load.feature@performance"))

  private val browseData = scenario("petclinic-browse-data")
    .exec(karateFeature("classpath:petclinic/performance/browse-load.feature@performance"))

  setUp(
    referenceData.inject(rampUsers(users) during (rampSeconds seconds)).protocols(protocol),
    browseData.inject(rampUsers(users) during (rampSeconds seconds)).protocols(protocol)
  ).assertions(
    global.failedRequests.count.is(0),
    global.responseTime.percentile(95).lt(750)
  )
}
