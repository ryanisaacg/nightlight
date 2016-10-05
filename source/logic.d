import arcade.geom;
import derelict.sdl2.sdl;
import std.math;
import std.stdio;

import entity;

struct GameConfig {
	float friction, accel, top_speed, min_speed, gravity, jump_speed, float_gravity;
}

void tick(State state, bool[SDL_Scancode] keys, GameConfig config) {
	//Define game step routines
	bool pressed(SDL_Scancode key) {
		bool *result = key in keys;
		return result !is null;
	}
	void physics(Entity *entity, float gravity = config.gravity) {
		Rect result;
		Vector2 speed;
		state.tiles.slide(entity.bounds, entity.speed, result, speed);
		entity.bounds = result;
		entity.speed = speed;
		entity.speed.y += gravity;
	}
	//Apply controls
	//Horizontal movement
	Entity *player = &(state.entities[0]);
	player.speed.x -= sgn(player.speed.x) * config.friction;
	player.speed.x = fmin(config.top_speed, fmax(-config.top_speed, player.speed.x));
	if(pressed(SDL_SCANCODE_D))
		player.speed.x += config.accel;
	if(pressed(SDL_SCANCODE_A))
		player.speed.x -= config.accel;
	if(abs(player.speed.x) < config.min_speed)
		player.speed.x = 0;
	//Jumping
	float gravity = config.gravity;
	if(pressed(SDL_SCANCODE_SPACE)) {
		gravity = config.float_gravity;
		if(!state.tiles.is_empty(player.bounds.move(Vector2(0, 1)))) 
			player.speed.y = config.jump_speed;
	}
	physics(&(state.entities[0]), gravity);
	//Apply physics
	for(int i = 1; i < state.amount; i++) {
		physics(&(state.entities[i]));
	}
}



