import arcade.geom;
import derelict.sdl2.sdl;
import std.math;
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
	Entity *player = &(state.entities[0]);
	player.speed.x -= sgn(player.speed.x) * 0.3;
	player.speed.x = fmin(3, fmax(-3, player.speed.x));
	if(pressed(SDL_SCANCODE_D))
		player.speed.x += 0.6f;
	if(pressed(SDL_SCANCODE_A))
		player.speed.x -= 0.6f;
	if(abs(player.speed.x) < 0.5f)
		player.speed.x = 0;
	//Apply physics
	for(int i = 0; i < state.amount; i++) {
		physics(&(state.entities[i]));
	}
}



