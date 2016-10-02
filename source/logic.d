import entity;

void tick(State *state) {
	foreach(ref entity; state.entities) {
		entity.bounds = entity.bounds.move(entity.speed);
	}
}
