package mcgagainst.stores

import java.util.concurrent.atomic.AtomicLong

import org.hashids.Hashids

class GameCodeManager(state: AtomicLong) {
    private val gameCodeEncoder = Hashids.reference("mcgagainst", 0, "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")

    def generate() = gameCodeEncoder.encode(state.incrementAndGet())
}
