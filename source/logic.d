import arcade.geom;
import entity;
import std.stdio;

void tick(State state) {
	for(int i = 0; i < state.amount; i++) {
		Entity *entity = &(state.entities[i]);
		Rect result;
		Vector2 speed;
		state.tiles.slide(entity.bounds, entity.speed, result, speed);
		entity.bounds = result;
		entity.speed = speed;
		//entity.bounds = entity.bounds.move(entity.speed);
	}
}



