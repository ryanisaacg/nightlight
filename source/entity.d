import arcade.geom;

struct Entity {
	Rect bounds;
	Vector2 speed;
}

struct State {
	Entity[] entities;
}
