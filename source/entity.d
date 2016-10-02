import arcade.geom;
import arcade.tilemap;
import derelict.sdl2.sdl;

alias Tiles = Tilemap!(SDL_Texture*, 640, 480, 32);


struct Entity {
	Rect bounds;
	Vector2 speed;
	SDL_Texture *texture = null;
	int health = 1;
}

struct State {
	Entity player;
	Entity[] entities;
	int amount = 0;
	Tiles tiles;
	
	this(int length) {
		entities.length = length;
	}
	
	void add(Entity e) {
		if(amount < entities.length / 2) {
			entities[amount] = e;
			amount ++;
		} else {
			entities.length *= 2;
			add(e);
		}
	}
	
	void remove(int i) {
		entities[i] = entities[amount - 1];
		amount -= 1;
	}
}
