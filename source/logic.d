import entity;

void tick(State *state) {
	foreach(e; state.entities) {
		e.bounds.x += 1;
	}
}
