package mcgagainst

import scala.concurrent.duration.FiniteDuration
import scala.concurrent.{Await, Future, Promise}
import scala.util.Try

object Util {
    def wait(duration: FiniteDuration): Try[Future[Nothing]] = Try(Await.ready(Promise().future, duration))
    
}
