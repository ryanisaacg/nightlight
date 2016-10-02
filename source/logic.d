import entity;
import std.stdio;

void single_tick(Entity[] entities, int i) {
	Entity *entity = &(entities[i]);
	entity.bounds = entity.bounds.move(entity.speed);
}

void tick(State state) {
	state.map!single_tick;
}
