import arcade.geom;

struct Entity {
	Rect bounds;
	Vector2 speed;
}

struct State {
	Entity[] entities;
	int amount = 0;
	
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
	
	template map(alias func) {
		void map() {
			for(int i = 0; i < amount; i++) {
				func(entities, i);
			}
		}
	}
}
