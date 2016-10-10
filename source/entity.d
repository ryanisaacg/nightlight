import arcade.geom;
import arcade.tilemap;
import multimedia.graphics;

alias Tiles = Tilemap!(Texture, 640, 480, 32);
alias IntTiles = Tilemap!(int[], 640, 480, 32);

enum EntityType { FIXTURE, CHARACTER, PROJECTILE }
enum EntityAlign { NEUTRAL, PLAYER, ENEMY }

struct Entity {
	Rect bounds;
	Vector2 speed;
	Texture texture;
	int health = 1;
	EntityType type;
	EntityAlign faction;
}

class State {
	Entity[] entities;
	int amount = 0;
	Tiles tiles;
	
	this(int length, Entity player) {
		entities.length = length;
		add(player);
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
