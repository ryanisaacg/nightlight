module arcade.geom;

import core.math;

/**
 * Vector2- A 2-Dimensional vector
 * Has some basic vector math functions
 */
struct Vector2 {
	float x, y;

	pure float len() {
		return sqrt(len2());
	}
	pure float len2() {
		return y * y + x * x;
	}
	pure Vector2 scale(float scalar) {
		return Vector2(x * scalar, y * scalar);
	}
	pure Vector2 normalize() {
		float length = len();
		return Vector2(x / length, y / length);
	}
	pure Vector2 setLength(float length) {
		return normalize().scale(length);
	}
	pure Vector2 opUnary(string op)() {
		static if(op == "+") return this;
		else static if(op == "-") return Vector2(-x, -y);
	}
	pure Vector2 opBinary(string op)(Vector2 other) {
		static if (op == "+") return Vector2(x + other.x, y + other.y);
		else static if (op == "-") return Vector2(x - other.x, y - other.y);
		else static assert(0, "Operator "~op~" not implemented");
	}
	pure Vector2 opBinary(string op)(float other) {
		static if (op == "*") return scale(other);
		else static if (op == "/") return Vector2(x / other, y / other);
		else static assert(0, "Operator "~op~" not implemented");
	}
}

///Compare two vectors
pure bool opEquals(Vector2 a, Vector2 b) {
	return a.x == b.x && a.y == b.y;
}

/**
 * Rect- an axis-aligned bounding box
 * Has very basic collision functions baked in
 */
struct Rect {
	float x, y, width, height;
	
	pure bool contains(Vector2 point) {
		return point.x >= x && point.y >= y && point.x < x + width && point.y + y + height;
	}
	
	pure bool overlaps(Rect other) {
		return x < other.x + other.width && x + width > other.x && y < other.y + other.height && y + height > other.y;
	}
	
	pure Rect move(Vector2 other) {
		return Rect(x + other.x, y + other.y, width, height);
	}
}

///Compare two rectangles
bool opEquals(Rect a, Rect b) {
	return a.x == b.x && a.y == b.y && a.width == b.width && a.height == b.height;
}

unittest {
	auto x = new Vector2(1, 2);
	auto y = new Vector2(2, 1);
	assert(x != y);
	assert(x == x);
}
