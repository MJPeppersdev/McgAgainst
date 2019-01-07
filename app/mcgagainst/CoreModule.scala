package mcgagainst

import com.google.inject.AbstractModule
import mcgagainst.stores.{InMemoryStore, LobbyStore}

class CoreModule extends AbstractModule {
    def configure = {
        bind(classOf[LobbyStore]).to(classOf[InMemoryStore])
    }
}
