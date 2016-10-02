import arcade.geom;
import std.stdio;

import entity;

void tick(State state) {
	void physics(Entity *entity) {
		Rect result;
		Vector2 speed;
		state.tiles.slide(entity.bounds, entity.speed, result, speed);
		entity.bounds = result;
		entity.speed = speed;
		entity.speed.y += 0.25f;
	}
	physics(&state.player);
	for(int i = 0; i < state.amount; i++) {
		physics(&(state.entities[i]));
	}
}



