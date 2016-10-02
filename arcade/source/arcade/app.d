import std.stdio;
import arcade.geom;
import arcade.map;

void main()
{
	Vector2 a, b;
	a.x = 5;
	a.y = 1;
	b.x = 1;
	b.y = 5;
	auto map = new Tilemap!(bool, 640, 480, 32)();
	map.put(true, Vector2(0, 0));
	map.put(true, Vector2(31, 31));
	auto r = Rect(35, 35, 4, 4);
	auto v = Vector2(-20, -20);
	map.move(r, v, r, v);
	writeln(r);
	auto c = a + b;
	writefln("%f", c.x );
}
