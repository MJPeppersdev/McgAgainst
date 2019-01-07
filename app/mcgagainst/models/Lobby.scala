package mcgagainst.models

import play.api.libs.json.{Json, Writes}
import mcgagainst.models.Game.Formatters._
import mcgagainst.models.Player.Formatters._


object Lobby {

  case class Lobby(gameCode: String, owner: Player.Id, config: Game.Config, players: List[Player], state: Game.State)

  case class LobbyAndHand(lobby: Lobby, hand: Game.Hand)

  case class GameCodeAndSecret(gameCode: String, secret: Player.Secret)

  object Formatters {
    implicit val lobbyWrites: Writes[Lobby] = Json.writes[Lobby]
    implicit val lobbyAndHandWrites: Writes[LobbyAndHand] = Json.writes[LobbyAndHand]
    implicit val gameCodeAndSecretWrites: Writes[GameCodeAndSecret] = Json.writes[GameCodeAndSecret]
  }

}
