import arcade.geom;
import derelict.sdl2.sdl;
import std.stdio;

import entity;

void tick(State state, bool[SDL_Scancode] keys) {
	//Define game step routines
	bool pressed(SDL_Scancode key) {
		bool *result = key in keys;
		return result !is null;
	}
	void physics(Entity *entity) {
		Rect result;
		Vector2 speed;
		state.tiles.slide(entity.bounds, entity.speed, result, speed);
		entity.bounds = result;
		entity.speed = speed;
		entity.speed.y += 0.25f;
	}
	//Apply controls
	if(pressed(SDL_SCANCODE_D))
		state.player.speed.x = 3;
	if(pressed(SDL_SCANCODE_A))
		state.player.speed.x = -3;
	//Apply physics
	physics(&state.player);
	for(int i = 0; i < state.amount; i++) {
		physics(&(state.entities[i]));
	}
}



